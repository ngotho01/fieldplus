import uuid
from django.db import models
from apps.jobs.models import Job


class Photo(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    job = models.ForeignKey(Job, on_delete=models.CASCADE, related_name='photos')
    field_id = models.CharField(max_length=100)
    file = models.FileField(upload_to='photos/')
    thumbnail_url = models.URLField(blank=True)
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    captured_at = models.DateTimeField()
    uploaded_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-captured_at']
        indexes = [models.Index(fields=['job', 'field_id'])]

    def __str__(self):
        return f'Photo {self.id} — job {self.job_id}'


class Signature(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    job = models.ForeignKey(Job, on_delete=models.CASCADE, related_name='signatures')
    field_id = models.CharField(max_length=100)
    file = models.FileField(upload_to='signatures/')
    captured_at = models.DateTimeField()
    uploaded_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f'Signature {self.id} — job {self.job_id}'