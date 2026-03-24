from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APIClient
from rest_framework import status
from django.utils import timezone
from datetime import timedelta
from django.core.files.uploadedfile import SimpleUploadedFile
from unittest.mock import patch

from apps.accounts.models import CustomUser
from apps.jobs.models import Job


def make_job(user):
    return Job.objects.create(
        technician=user,
        customer_name='Test',
        customer_phone='000',
        address='Test St',
        description='desc',
        scheduled_start=timezone.now(),
        scheduled_end=timezone.now() + timedelta(hours=1),
    )


class PhotoUploadTests(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = CustomUser.objects.create_user(email='t@fp.com', password='pw')
        self.client.force_authenticate(user=self.user)

    @patch('apps.media.storage.MinIOStorage._ensure_bucket')
    def test_photo_upload_forbidden_for_other_user(self, _mock):
        other = CustomUser.objects.create_user(email='o@fp.com', password='pw')
        job = make_job(other)
        img = SimpleUploadedFile('photo.jpg', b'\xff\xd8\xff', content_type='image/jpeg')
        r = self.client.post(
            reverse('photo-upload'),
            {'job': str(job.id), 'field_id': 'site_photo',
             'captured_at': timezone.now().isoformat(), 'file': img},
            format='multipart',
        )
        self.assertEqual(r.status_code, status.HTTP_404_NOT_FOUND)