import uuid
from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()


class Job(models.Model):
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('in_progress', 'In Progress'),
        ('completed', 'Completed'),
    ]

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    technician = models.ForeignKey(User, on_delete=models.CASCADE, related_name='jobs')
    customer_name = models.CharField(max_length=255)
    customer_phone = models.CharField(max_length=20)
    address = models.TextField()
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    description = models.TextField()
    notes = models.TextField(blank=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    scheduled_start = models.DateTimeField()
    scheduled_end = models.DateTimeField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    server_version = models.IntegerField(default=1)

    class Meta:
        ordering = ['scheduled_start']
        indexes = [
            models.Index(fields=['technician', 'status']),
            models.Index(fields=['scheduled_start']),
            models.Index(fields=['status']),
        ]

    def __str__(self):
        return f'{self.customer_name} — {self.status}'

    def advance_version(self):
        self.server_version += 1
        self.save(update_fields=['server_version', 'updated_at'])


class ChecklistSchema(models.Model):
    job = models.OneToOneField(Job, on_delete=models.CASCADE, related_name='checklist_schema')
    schema = models.JSONField()
    version = models.IntegerField(default=1)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f'Schema for {self.job}'