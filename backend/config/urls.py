from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/auth/', include('apps.accounts.urls')),
    path('api/jobs/', include('apps.jobs.urls')),
    path('api/checklist/', include('apps.checklist.urls')),
    path('api/media/', include('apps.media.urls')),
    path('api/sync/', include('apps.sync.urls')),
]