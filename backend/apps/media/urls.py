from django.urls import path
from .views import PhotoUploadView, PhotoDetailView, SignatureUploadView

urlpatterns = [
    path('photo/', PhotoUploadView.as_view(), name='photo-upload'),
    path('photo/<uuid:pk>/', PhotoDetailView.as_view(), name='photo-detail'),
    path('signature/', SignatureUploadView.as_view(), name='signature-upload'),
]