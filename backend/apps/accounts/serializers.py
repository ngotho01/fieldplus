from rest_framework import serializers
from django.contrib.auth import authenticate
from .models import CustomUser


class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True, min_length=6)

    def validate(self, data):
        user = authenticate(username=data['email'], password=data['password'])
        if not user:
            raise serializers.ValidationError('Invalid credentials.')
        if not user.is_active:
            raise serializers.ValidationError('Account is disabled.')
        data['user'] = user
        return data


class UserSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(read_only=True)

    class Meta:
        model = CustomUser
        fields = [
            'id', 'email', 'first_name', 'last_name',
            'full_name', 'phone', 'avatar_url', 'created_at',
        ]
        read_only_fields = ['id', 'created_at']


class FCMTokenSerializer(serializers.Serializer):
    token = serializers.CharField(max_length=500)