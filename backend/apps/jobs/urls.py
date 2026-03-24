from django.urls import path
from .views import JobListView, JobDetailView, JobStatusUpdateView, JobSchemaView

urlpatterns = [
    path('', JobListView.as_view(), name='job-list'),
    path('<uuid:pk>/', JobDetailView.as_view(), name='job-detail'),
    path('<uuid:pk>/status/', JobStatusUpdateView.as_view(), name='job-status-update'),
    path('<uuid:pk>/schema/', JobSchemaView.as_view(), name='job-schema'),
]