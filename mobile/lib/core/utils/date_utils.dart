import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static final _dateFormatter     = DateFormat('MMM d, yyyy');
  static final _timeFormatter     = DateFormat('h:mm a');
  static final _dateTimeFormatter = DateFormat('MMM d, yyyy • h:mm a');
  static final _isoFormatter      = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
  static final _overlayFormatter  = DateFormat('yyyy-MM-dd HH:mm:ss');

  static String formatDate(DateTime dt)     => _dateFormatter.format(dt.toLocal());
  static String formatTime(DateTime dt)     => _timeFormatter.format(dt.toLocal());
  static String formatDateTime(DateTime dt) => _dateTimeFormatter.format(dt.toLocal());
  static String formatOverlay(DateTime dt)  => _overlayFormatter.format(dt.toLocal());
  static String toIso(DateTime dt)          => _isoFormatter.format(dt.toUtc());

  static bool isOverdue(DateTime scheduledEnd) =>
      scheduledEnd.isBefore(DateTime.now());

  static String relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1)  return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24)   return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  static String scheduleWindow(DateTime start, DateTime end) {
    final s = formatDateTime(start);
    final e = formatTime(end);
    return '$s – $e';
  }
}