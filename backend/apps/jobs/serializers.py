from rest_framework import serializers
from .models import Job, ChecklistSchema


class ChecklistSchemaSerializer(serializers.ModelSerializer):
    class Meta:
        model = ChecklistSchema
        fields = ['schema', 'version']


class JobListSerializer(serializers.ModelSerializer):
    has_schema = serializers.SerializerMethodField()
    has_response = serializers.SerializerMethodField()
    is_overdue = serializers.SerializerMethodField()

    class Meta:
        model = Job
        fields = [
            'id', 'customer_name', 'customer_phone', 'address',
            'latitude', 'longitude', 'status', 'scheduled_start',
            'scheduled_end', 'server_version', 'has_schema',
            'has_response', 'is_overdue', 'updated_at',
        ]

    def get_has_schema(self, obj):
        return hasattr(obj, 'checklist_schema')

    def get_has_response(self, obj):
        return hasattr(obj, 'response')

    def get_is_overdue(self, obj):
        from django.utils import timezone
        return obj.scheduled_end < timezone.now() and obj.status != 'completed'


class JobDetailSerializer(serializers.ModelSerializer):
    checklist_schema = ChecklistSchemaSerializer(read_only=True)
    photo_count = serializers.SerializerMethodField()
    is_overdue = serializers.SerializerMethodField()

    class Meta:
        model = Job
        fields = [
            'id', 'customer_name', 'customer_phone', 'address',
            'latitude', 'longitude', 'description', 'notes',
            'status', 'scheduled_start', 'scheduled_end',
            'checklist_schema', 'server_version', 'photo_count',
            'is_overdue', 'created_at', 'updated_at',
        ]

    def get_photo_count(self, obj):
        return obj.photos.count()

    def get_is_overdue(self, obj):
        from django.utils import timezone
        return obj.scheduled_end < timezone.now() and obj.status != 'completed'


class JobStatusUpdateSerializer(serializers.Serializer):
    status = serializers.ChoiceField(choices=Job.STATUS_CHOICES)
    client_version = serializers.IntegerField(
        help_text='Current server_version held by the client; used for conflict detection.'
    )