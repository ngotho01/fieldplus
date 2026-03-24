from django.contrib import admin
from .models import Job, ChecklistSchema


class ChecklistSchemaInline(admin.StackedInline):
    model = ChecklistSchema
    extra = 0


@admin.register(Job)
class JobAdmin(admin.ModelAdmin):
    list_display = ['customer_name', 'technician', 'status', 'scheduled_start', 'server_version']
    list_filter = ['status', 'technician']
    search_fields = ['customer_name', 'address', 'description']
    inlines = [ChecklistSchemaInline]
    readonly_fields = ['id', 'created_at', 'updated_at', 'server_version']