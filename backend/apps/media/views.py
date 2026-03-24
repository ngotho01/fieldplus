from rest_framework import status
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser
from django.shortcuts import get_object_or_404
from django_ratelimit.decorators import ratelimit
from django.utils.decorators import method_decorator

from apps.jobs.models import Job
from .models import Photo, Signature
from .serializers import (
    PhotoSerializer, PhotoUploadSerializer,
    SignatureSerializer, SignatureUploadSerializer,
)


class PhotoUploadView(APIView):
    """
    POST /api/media/photo/
    Upload a single photo (multipart/form-data).
    """
    permission_classes = [IsAuthenticated]
    parser_classes = [MultiPartParser, FormParser]

    @method_decorator(ratelimit(key='user', rate='100/h', method='POST', block=True))
    def post(self, request):
        # Verify job ownership
        job_id = request.data.get('job')
        get_object_or_404(Job, pk=job_id, technician=request.user)

        serializer = PhotoUploadSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        photo = serializer.save()

        return Response(
            {'success': True, 'data': PhotoSerializer(photo).data},
            status=status.HTTP_201_CREATED,
        )


class PhotoDetailView(APIView):
    """
    GET /api/media/photo/{id}/
    Return pre-signed URL for a photo.
    """
    permission_classes = [IsAuthenticated]

    def get(self, request, pk):
        photo = get_object_or_404(Photo, pk=pk, job__technician=request.user)
        return Response({'success': True, 'data': PhotoSerializer(photo).data})


class SignatureUploadView(APIView):
    """
    POST /api/media/signature/
    Upload a signature PNG (multipart/form-data).
    """
    permission_classes = [IsAuthenticated]
    parser_classes = [MultiPartParser, FormParser]

    def post(self, request):
        job_id = request.data.get('job')
        get_object_or_404(Job, pk=job_id, technician=request.user)

        serializer = SignatureUploadSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        sig = serializer.save()

        return Response(
            {'success': True, 'data': SignatureSerializer(sig).data},
            status=status.HTTP_201_CREATED,
        )