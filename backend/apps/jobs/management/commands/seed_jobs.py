from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from django.utils import timezone
from apps.jobs.models import Job, ChecklistSchema
from faker import Faker
import random
from datetime import timedelta

User = get_user_model()
fake = Faker()

SCHEMA = {
    'version': 1,
    'fields': [
        {
            'id': 'site_condition', 'type': 'select',
            'label': 'Site Condition', 'required': True,
            'options': ['Clean', 'Damaged', 'Under Construction', 'Needs Attention'],
        },
        {
            'id': 'technician_notes', 'type': 'textarea',
            'label': 'Technician Notes', 'required': False, 'max_length': 1000,
        },
        {
            'id': 'meter_reading', 'type': 'number',
            'label': 'Meter Reading', 'required': True, 'min': 0, 'max': 99999,
        },
        {
            'id': 'issues_found', 'type': 'multi_select',
            'label': 'Issues Found', 'required': False,
            'options': ['Wiring', 'Plumbing', 'Structural', 'Electrical', 'None'],
        },
        {
            'id': 'site_photo', 'type': 'photo',
            'label': 'Site Photo', 'required': True, 'max_photos': 3,
        },
        {
            'id': 'client_signature', 'type': 'signature',
            'label': 'Client Signature', 'required': True,
        },
        {
            'id': 'inspection_date', 'type': 'datetime',
            'label': 'Inspection Date & Time', 'required': True,
        },
        {
            'id': 'safety_check', 'type': 'checkbox',
            'label': 'Safety checks completed', 'required': True,
        },
    ],
}


class Command(BaseCommand):
    help = 'Seed the database with 120 sample jobs and a technician account.'

    def add_arguments(self, parser):
        parser.add_argument('--count', type=int, default=120)

    def handle(self, *args, **options):
        count = options['count']

        user, created = User.objects.get_or_create(
            email='tech@fieldpulse.com',
            defaults={
                'first_name': 'John',
                'last_name': 'Tech',
                'is_active': True,
            },
        )
        user.set_password('password123')
        user.save()

        if created:
            self.stdout.write(f'  Created user: tech@fieldpulse.com / password123')
        else:
            self.stdout.write(f'  User already exists: tech@fieldpulse.com')

        statuses = ['pending', 'in_progress', 'completed']
        weights = [0.5, 0.3, 0.2]

        created_count = 0
        for _ in range(count):
            offset_hours = random.randint(-72, 168)  # -3 days to +7 days
            start = timezone.now() + timedelta(hours=offset_hours)
            end = start + timedelta(hours=random.randint(1, 4))

            job = Job.objects.create(
                technician=user,
                customer_name=fake.name(),
                customer_phone=fake.phone_number()[:15],
                address=fake.address().replace('\n', ', '),
                latitude=round(float(fake.latitude()), 6),
                longitude=round(float(fake.longitude()), 6),
                description=fake.paragraph(nb_sentences=3),
                notes=fake.sentence() if random.random() > 0.4 else '',
                status=random.choices(statuses, weights=weights)[0],
                scheduled_start=start,
                scheduled_end=end,
            )
            ChecklistSchema.objects.create(job=job, schema=SCHEMA)
            created_count += 1

        self.stdout.write(
            self.style.SUCCESS(f'✅ Seeded {created_count} jobs with checklist schemas.')
        )