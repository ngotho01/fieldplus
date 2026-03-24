from rest_framework import serializers
from .models import Photo, Signature


class PhotoSerializer(serializers.ModelSerializer):
    file_url = serializers.SerializerMethodField()

    class Meta:
        model = Photo
        fields = [
            'id', 'job', 'field_id', 'file', 'file_url',
            'thumbnail_url', 'latitude', 'longitude',
            'captured_at', 'uploaded_at',
        ]
        read_only_fields = ['id', 'uploaded_at', 'file_url']

    def get_file_url(self, obj):
        try:
            return obj.file.url
        except Exception:
            return None


class PhotoUploadSerializer(serializers.ModelSerializer):
    class Meta:
        model = Photo
        fields = ['job', 'field_id', 'file', 'latitude', 'longitude', 'captured_at']


class SignatureSerializer(serializers.ModelSerializer):
    file_url = serializers.SerializerMethodField()

    class Meta:
        model = Signature
        fields = ['id', 'job', 'field_id', 'file', 'file_url', 'captured_at', 'uploaded_at']
        read_only_fields = ['id', 'uploaded_at', 'file_url']

    def get_file_url(self, obj):
        try:
            return obj.file.url
        except Exception:
            return None


class SignatureUploadSerializer(serializers.ModelSerializer):
    class Meta:
        model = Signature
        fields = ['job', 'field_id', 'file', 'captured_at']