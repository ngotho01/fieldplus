from django.urls import path
from .views import BulkSyncView, ConflictResolveView

urlpatterns = [
    path('bulk/', BulkSyncView.as_view(), name='sync-bulk'),
    path('conflict/resolve/', ConflictResolveView.as_view(), name='sync-conflict-resolve'),
]