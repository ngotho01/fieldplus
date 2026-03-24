from rest_framework import serializers
from .models import ChecklistResponse


class ChecklistResponseSerializer(serializers.ModelSerializer):
    class Meta:
        model = ChecklistResponse
        fields = [
            'id', 'job', 'responses', 'is_draft',
            'submitted_at', 'created_at', 'updated_at',
        ]
        read_only_fields = ['id', 'submitted_at', 'created_at', 'updated_at']


class ChecklistSubmitSerializer(serializers.Serializer):
    responses = serializers.DictField(
        child=serializers.JSONField(),
        help_text='Map of field_id → value',
    )

    def validate_responses(self, value):
        if not value:
            raise serializers.ValidationError('Responses cannot be empty.')
        return value


class ChecklistDraftSerializer(serializers.Serializer):
    responses = serializers.DictField(child=serializers.JSONField())