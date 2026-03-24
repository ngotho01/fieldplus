from rest_framework.pagination import CursorPagination


class JobCursorPagination(CursorPagination):
    page_size = 20
    page_size_query_param = 'page_size'
    max_page_size = 100
    ordering = 'scheduled_start'
    cursor_query_param = 'cursor'