from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APIClient
from rest_framework import status
from django.utils import timezone
from datetime import timedelta
from apps.accounts.models import CustomUser
from .models import Job, ChecklistSchema


def make_job(user, **kwargs):
    defaults = dict(
        technician=user,
        customer_name='Alice',
        customer_phone='0712345678',
        address='123 Main St',
        description='Fix the thing',
        scheduled_start=timezone.now() + timedelta(hours=1),
        scheduled_end=timezone.now() + timedelta(hours=3),
    )
    defaults.update(kwargs)
    return Job.objects.create(**defaults)


class JobListTests(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = CustomUser.objects.create_user(
            email='tech@fieldpulse.com', password='pw'
        )
        self.client.force_authenticate(user=self.user)

    def test_job_list_returns_only_own_jobs(self):
        other = CustomUser.objects.create_user(email='other@fp.com', password='pw')
        make_job(self.user, customer_name='Mine')
        make_job(other, customer_name='Not Mine')
        r = self.client.get(reverse('job-list'))
        self.assertEqual(r.status_code, status.HTTP_200_OK)
        names = [j['customer_name'] for j in r.data['results']]
        self.assertIn('Mine', names)
        self.assertNotIn('Not Mine', names)

    def test_filter_by_status(self):
        make_job(self.user, status='pending')
        make_job(self.user, status='completed')
        r = self.client.get(reverse('job-list'), {'status': 'pending'})
        self.assertTrue(all(j['status'] == 'pending' for j in r.data['results']))

    def test_status_update_conflict(self):
        job = make_job(self.user)
        job.server_version = 5
        job.save()
        r = self.client.patch(
            reverse('job-status-update', args=[job.id]),
            {'status': 'in_progress', 'client_version': 1},
        )
        self.assertEqual(r.status_code, status.HTTP_409_CONFLICT)
        self.assertTrue(r.data['conflict'])

    def test_status_update_success(self):
        job = make_job(self.user)
        r = self.client.patch(
            reverse('job-status-update', args=[job.id]),
            {'status': 'in_progress', 'client_version': 1},
        )
        self.assertEqual(r.status_code, status.HTTP_200_OK)
        job.refresh_from_db()
        self.assertEqual(job.status, 'in_progress')
        self.assertEqual(job.server_version, 2)