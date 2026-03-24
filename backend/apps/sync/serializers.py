from rest_framework import serializers


class BulkJobSyncSerializer(serializers.Serializer):
    """Single job payload inside bulk sync."""
    job_id = serializers.UUIDField()
    status = serializers.ChoiceField(choices=['pending', 'in_progress', 'completed'])
    client_version = serializers.IntegerField()
    responses = serializers.DictField(child=serializers.JSONField(), required=False, default=dict)


class BulkSyncSerializer(serializers.Serializer):
    jobs = BulkJobSyncSerializer(many=True)


class ConflictResolveSerializer(serializers.Serializer):
    RESOLUTION_CHOICES = ['keep_local', 'accept_server', 'merge']

    job_id = serializers.UUIDField()
    resolution = serializers.ChoiceField(choices=RESOLUTION_CHOICES)
    merged_responses = serializers.DictField(
        child=serializers.JSONField(),
        required=False,
        help_text='Required only when resolution=merge',
    )

    def validate(self, data):
        if data['resolution'] == 'merge' and not data.get('merged_responses'):
            raise serializers.ValidationError(
                'merged_responses required when resolution is "merge".'
            )
        return data