from rest_framework import status
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.shortcuts import get_object_or_404
from django.utils import timezone

from apps.jobs.models import Job
from apps.checklist.models import ChecklistResponse
from .serializers import BulkSyncSerializer, ConflictResolveSerializer


class BulkSyncView(APIView):
    """
    POST /api/sync/bulk/
    Accepts an array of job updates. Each item is processed individually;
    conflicts are reported per-job without aborting the whole batch.
    """
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = BulkSyncSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        results = []
        for item in serializer.validated_data['jobs']:
            job_id = item['job_id']
            try:
                job = Job.objects.get(pk=job_id, technician=request.user)
            except Job.DoesNotExist:
                results.append({'job_id': str(job_id), 'success': False, 'error': 'Not found'})
                continue

            if job.server_version != item['client_version']:
                results.append({
                    'job_id': str(job_id),
                    'success': False,
                    'conflict': True,
                    'server_version': job.server_version,
                    'server_status': job.status,
                })
                continue

            job.status = item['status']
            job.server_version += 1
            job.save(update_fields=['status', 'server_version', 'updated_at'])

            if item.get('responses'):
                ChecklistResponse.objects.update_or_create(
                    job=job,
                    defaults={
                        'technician': request.user,
                        'responses': item['responses'],
                        'is_draft': False,
                        'submitted_at': timezone.now(),
                    },
                )

            results.append({
                'job_id': str(job_id),
                'success': True,
                'server_version': job.server_version,
            })

        return Response({'success': True, 'results': results})


class ConflictResolveView(APIView):
    """
    POST /api/sync/conflict/resolve/
    """
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = ConflictResolveSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        data = serializer.validated_data
        job = get_object_or_404(Job, pk=data['job_id'], technician=request.user)

        resolution = data['resolution']

        if resolution == 'accept_server':
            # Nothing changes on the server; just return current server state
            pass

        elif resolution == 'keep_local':
            # Client will send a follow-up status update — bump version to allow it
            job.server_version += 1
            job.save(update_fields=['server_version', 'updated_at'])

        elif resolution == 'merge':
            merged = data['merged_responses']
            ChecklistResponse.objects.update_or_create(
                job=job,
                defaults={
                    'technician': request.user,
                    'responses': merged,
                    'is_draft': False,
                    'submitted_at': timezone.now(),
                },
            )
            job.server_version += 1
            job.save(update_fields=['server_version', 'updated_at'])

        from apps.jobs.serializers import JobDetailSerializer
        return Response({
            'success': True,
            'resolution': resolution,
            'job': JobDetailSerializer(job).data,
        })