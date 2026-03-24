from django.urls import path
from .views import SaveDraftView, SubmitChecklistView, GetChecklistResponseView

urlpatterns = [
    path('<uuid:job_id>/', GetChecklistResponseView.as_view(), name='checklist-get'),
    path('<uuid:job_id>/draft/', SaveDraftView.as_view(), name='checklist-draft'),
    path('<uuid:job_id>/submit/', SubmitChecklistView.as_view(), name='checklist-submit'),
]