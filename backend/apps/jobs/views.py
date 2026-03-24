from rest_framework import status
from rest_framework.views import APIView
from rest_framework.generics import ListAPIView, RetrieveAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django_ratelimit.decorators import ratelimit
from django.utils.decorators import method_decorator
from django.shortcuts import get_object_or_404

from .models import Job, ChecklistSchema
from .serializers import (
    JobListSerializer, JobDetailSerializer,
    JobStatusUpdateSerializer, ChecklistSchemaSerializer,
)
from .filters import JobFilter
from .pagination import JobCursorPagination


class JobListView(ListAPIView):
    """
    GET /api/jobs/
    Returns paginated, filterable list of jobs for the authenticated technician.
    """
    permission_classes = [IsAuthenticated]
    serializer_class = JobListSerializer
    filterset_class = JobFilter
    pagination_class = JobCursorPagination
    search_fields = ['customer_name', 'address', 'description']
    ordering_fields = ['scheduled_start', 'updated_at', 'status']

    def get_queryset(self):
        return (
            Job.objects
            .filter(technician=self.request.user)
            .select_related('checklist_schema')
            .prefetch_related('photos')
        )


class JobDetailView(RetrieveAPIView):
    """
    GET /api/jobs/{id}/
    Full job detail including checklist schema.
    """
    permission_classes = [IsAuthenticated]
    serializer_class = JobDetailSerializer

    def get_queryset(self):
        return Job.objects.filter(technician=self.request.user).select_related(
            'checklist_schema'
        ).prefetch_related('photos', 'signatures')


class JobStatusUpdateView(APIView):
    """
    PATCH /api/jobs/{id}/status/
    Update job status with optimistic concurrency (server_version check).
    """
    permission_classes = [IsAuthenticated]

    @method_decorator(ratelimit(key='user', rate='60/m', method='PATCH', block=True))
    def patch(self, request, pk):
        job = get_object_or_404(Job, pk=pk, technician=request.user)
        serializer = JobStatusUpdateSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        client_version = serializer.validated_data['client_version']
        new_status = serializer.validated_data['status']

        if job.server_version != client_version:
            return Response(
                {
                    'success': False,
                    'conflict': True,
                    'server_version': job.server_version,
                    'server_status': job.status,
                    'message': 'Job was modified on the server. Resolve conflict before updating.',
                },
                status=status.HTTP_409_CONFLICT,
            )

        job.status = new_status
        job.server_version += 1
        job.save(update_fields=['status', 'server_version', 'updated_at'])

        return Response({
            'success': True,
            'status': job.status,
            'server_version': job.server_version,
        })


class JobSchemaView(APIView):
    """
    GET /api/jobs/{id}/schema/
    Returns the checklist schema for a job.
    """
    permission_classes = [IsAuthenticated]

    def get(self, request, pk):
        job = get_object_or_404(Job, pk=pk, technician=request.user)
        try:
            schema = job.checklist_schema
        except ChecklistSchema.DoesNotExist:
            return Response(
                {'success': False, 'errors': 'No schema defined for this job.'},
                status=status.HTTP_404_NOT_FOUND,
            )
        return Response({
            'success': True,
            'schema': ChecklistSchemaSerializer(schema).data,
        })