import uuid
from django.db import models
from django.contrib.auth import get_user_model
from apps.jobs.models import Job

User = get_user_model()


class ChecklistResponse(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    job = models.OneToOneField(Job, on_delete=models.CASCADE, related_name='response')
    technician = models.ForeignKey(User, on_delete=models.CASCADE, related_name='checklist_responses')
    responses = models.JSONField(default=dict)
    is_draft = models.BooleanField(default=True)
    submitted_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        indexes = [models.Index(fields=['job', 'technician'])]

    def __str__(self):
        state = 'Draft' if self.is_draft else 'Submitted'
        return f'{state} — {self.job}'