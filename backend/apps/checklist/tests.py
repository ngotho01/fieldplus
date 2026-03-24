from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APIClient
from rest_framework import status
from django.utils import timezone
from datetime import timedelta

from apps.accounts.models import CustomUser
from apps.jobs.models import Job, ChecklistSchema

SCHEMA = {
    'version': 1,
    'fields': [
        {'id': 'condition', 'type': 'select', 'label': 'Condition',
         'required': True, 'options': ['Clean', 'Damaged']},
        {'id': 'reading', 'type': 'number', 'label': 'Reading',
         'required': True, 'min': 0, 'max': 9999},
        {'id': 'safety', 'type': 'checkbox', 'label': 'Safety OK', 'required': True},
    ],
}


def make_job_with_schema(user):
    job = Job.objects.create(
        technician=user,
        customer_name='Bob',
        customer_phone='0700000000',
        address='Test St',
        description='Test job',
        scheduled_start=timezone.now(),
        scheduled_end=timezone.now() + timedelta(hours=2),
    )
    ChecklistSchema.objects.create(job=job, schema=SCHEMA)
    return job


class ChecklistTests(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = CustomUser.objects.create_user(email='t@fp.com', password='pw')
        self.client.force_authenticate(user=self.user)

    def test_submit_valid_checklist(self):
        job = make_job_with_schema(self.user)
        r = self.client.post(
            reverse('checklist-submit', args=[job.id]),
            {'responses': {'condition': 'Clean', 'reading': 100, 'safety': True}},
            format='json',
        )
        self.assertEqual(r.status_code, status.HTTP_201_CREATED)
        self.assertTrue(r.data['success'])

    def test_submit_missing_required_field(self):
        job = make_job_with_schema(self.user)
        r = self.client.post(
            reverse('checklist-submit', args=[job.id]),
            {'responses': {'reading': 100}},
            format='json',
        )
        self.assertEqual(r.status_code, status.HTTP_422_UNPROCESSABLE_ENTITY)
        self.assertFalse(r.data['success'])

    def test_save_and_retrieve_draft(self):
        job = make_job_with_schema(self.user)
        self.client.post(
            reverse('checklist-draft', args=[job.id]),
            {'responses': {'condition': 'Damaged'}},
            format='json',
        )
        r = self.client.get(reverse('checklist-get', args=[job.id]))
        self.assertEqual(r.status_code, status.HTTP_200_OK)
        self.assertEqual(r.data['data']['responses']['condition'], 'Damaged')
        self.assertTrue(r.data['data']['is_draft'])