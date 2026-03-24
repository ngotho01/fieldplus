from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APIClient
from rest_framework import status
from .models import CustomUser


class AuthTests(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = CustomUser.objects.create_user(
            email='tech@fieldpulse.com',
            password='password123',
            first_name='John',
            last_name='Tech',
        )

    def test_login_success(self):
        response = self.client.post(reverse('auth-login'), {
            'email': 'tech@fieldpulse.com',
            'password': 'password123',
        })
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('access', response.data)
        self.assertIn('refresh', response.data)
        self.assertTrue(response.data['success'])

    def test_login_invalid_credentials(self):
        response = self.client.post(reverse('auth-login'), {
            'email': 'tech@fieldpulse.com',
            'password': 'wrongpassword',
        })
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_profile_requires_auth(self):
        response = self.client.get(reverse('auth-profile'))
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_profile_authenticated(self):
        self.client.force_authenticate(user=self.user)
        response = self.client.get(reverse('auth-profile'))
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['user']['email'], 'tech@fieldpulse.com')

    def test_logout_blacklists_token(self):
        login = self.client.post(reverse('auth-login'), {
            'email': 'tech@fieldpulse.com',
            'password': 'password123',
        })
        refresh_token = login.data['refresh']
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {login.data['access']}")
        response = self.client.post(reverse('auth-logout'), {'refresh': refresh_token})
        self.assertEqual(response.status_code, status.HTTP_200_OK)