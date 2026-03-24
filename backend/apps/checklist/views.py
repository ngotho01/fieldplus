from rest_framework import status
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.shortcuts import get_object_or_404
from django.utils import timezone

from apps.jobs.models import Job, ChecklistSchema
from .models import ChecklistResponse
from .serializers import ChecklistSubmitSerializer, ChecklistDraftSerializer, ChecklistResponseSerializer


def _validate_against_schema(schema, responses):
    """
    Validate responses against the checklist schema.
    Returns list of error messages (empty = valid).
    """
    errors = []
    for field in schema.get('fields', []):
        fid = field['id']
        required = field.get('required', False)
        value = responses.get(fid)

        if required and (value is None or value == '' or value == [] or value == False):
            if field['type'] != 'checkbox':
                errors.append(f"Field '{field['label']}' is required.")
            elif value is not True:
                errors.append(f"Field '{field['label']}' must be checked.")
            continue

        if value is None:
            continue

        ftype = field['type']

        if ftype == 'number':
            try:
                num = float(value)
                if 'min' in field and num < field['min']:
                    errors.append(f"'{field['label']}' must be ≥ {field['min']}.")
                if 'max' in field and num > field['max']:
                    errors.append(f"'{field['label']}' must be ≤ {field['max']}.")
            except (TypeError, ValueError):
                errors.append(f"'{field['label']}' must be a number.")

        elif ftype == 'textarea':
            max_len = field.get('max_length')
            if max_len and len(str(value)) > max_len:
                errors.append(f"'{field['label']}' exceeds max length of {max_len}.")

        elif ftype == 'select':
            options = field.get('options', [])
            if value not in options:
                errors.append(f"'{field['label']}' must be one of: {options}.")

        elif ftype == 'multi_select':
            options = field.get('options', [])
            if not isinstance(value, list):
                errors.append(f"'{field['label']}' must be a list.")
            else:
                invalid = [v for v in value if v not in options]
                if invalid:
                    errors.append(f"'{field['label']}' contains invalid options: {invalid}.")

    return errors


class SaveDraftView(APIView):
    """
    POST /api/checklist/{job_id}/draft/
    Upsert a draft checklist response.
    """
    permission_classes = [IsAuthenticated]

    def post(self, request, job_id):
        job = get_object_or_404(Job, pk=job_id, technician=request.user)
        serializer = ChecklistDraftSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        response_obj, created = ChecklistResponse.objects.update_or_create(
            job=job,
            defaults={
                'technician': request.user,
                'responses': serializer.validated_data['responses'],
                'is_draft': True,
            },
        )

        return Response({
            'success': True,
            'created': created,
            'data': ChecklistResponseSerializer(response_obj).data,
        }, status=status.HTTP_201_CREATED if created else status.HTTP_200_OK)


class SubmitChecklistView(APIView):
    """
    POST /api/checklist/{job_id}/submit/
    Validate and finalize a checklist response.
    """
    permission_classes = [IsAuthenticated]

    def post(self, request, job_id):
        job = get_object_or_404(Job, pk=job_id, technician=request.user)

        if not hasattr(job, 'checklist_schema'):
            return Response(
                {'success': False, 'errors': 'This job has no checklist schema.'},
                status=status.HTTP_400_BAD_REQUEST,
            )

        serializer = ChecklistSubmitSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        responses = serializer.validated_data['responses']
        schema = job.checklist_schema.schema
        errors = _validate_against_schema(schema, responses)

        if errors:
            return Response(
                {'success': False, 'errors': errors},
                status=status.HTTP_422_UNPROCESSABLE_ENTITY,
            )

        response_obj, _ = ChecklistResponse.objects.update_or_create(
            job=job,
            defaults={
                'technician': request.user,
                'responses': responses,
                'is_draft': False,
                'submitted_at': timezone.now(),
            },
        )

        # Advance job version on completion
        if job.status != 'completed':
            job.status = 'completed'
            job.server_version += 1
            job.save(update_fields=['status', 'server_version', 'updated_at'])

        return Response({
            'success': True,
            'data': ChecklistResponseSerializer(response_obj).data,
        }, status=status.HTTP_201_CREATED)


class GetChecklistResponseView(APIView):
    """
    GET /api/checklist/{job_id}/
    Fetch existing response (draft or submitted).
    """
    permission_classes = [IsAuthenticated]

    def get(self, request, job_id):
        job = get_object_or_404(Job, pk=job_id, technician=request.user)
        try:
            response_obj = job.response
        except ChecklistResponse.DoesNotExist:
            return Response({'success': True, 'data': None})
        return Response({
            'success': True,
            'data': ChecklistResponseSerializer(response_obj).data,
        })