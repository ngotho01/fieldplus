import django_filters
from django.db.models import Q
from .models import Job


class JobFilter(django_filters.FilterSet):
    status = django_filters.ChoiceFilter(choices=Job.STATUS_CHOICES)
    start_after = django_filters.DateTimeFilter(field_name='scheduled_start', lookup_expr='gte')
    start_before = django_filters.DateTimeFilter(field_name='scheduled_start', lookup_expr='lte')
    search = django_filters.CharFilter(method='filter_search')
    updated_after = django_filters.DateTimeFilter(field_name='updated_at', lookup_expr='gte')

    class Meta:
        model = Job
        fields = ['status', 'start_after', 'start_before', 'search', 'updated_after']

    def filter_search(self, queryset, name, value):
        return queryset.filter(
            Q(customer_name__icontains=value) |
            Q(address__icontains=value) |
            Q(description__icontains=value)
        )