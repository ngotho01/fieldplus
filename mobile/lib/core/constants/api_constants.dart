class ApiConstants {
  ApiConstants._();

  // static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Physical Phone (uncomment this, comment the one above)
  static const String baseUrl = 'http://192.168.100.55:8000/api';

  // Auth
  static const String login    = '/auth/login/';
  static const String refresh  = '/auth/refresh/';
  static const String logout   = '/auth/logout/';
  static const String profile  = '/auth/profile/';
  static const String fcmRegister = '/auth/notifications/register/';

  // Jobs
  static const String jobs = '/jobs/';
  static String jobDetail(String id) => '/jobs/$id/';
  static String jobStatus(String id) => '/jobs/$id/status/';
  static String jobSchema(String id) => '/jobs/$id/schema/';

  // Checklist
  static String checklistDraft(String jobId)  => '/checklist/$jobId/draft/';
  static String checklistSubmit(String jobId) => '/checklist/$jobId/submit/';
  static String checklistGet(String jobId)    => '/checklist/$jobId/';

  // Media
  static const String photoUpload     = '/media/photo/';
  static String photoDetail(String id) => '/media/photo/$id/';
  static const String signatureUpload = '/media/signature/';

  // Sync
  static const String syncBulk            = '/sync/bulk/';
  static const String syncConflictResolve = '/sync/conflict/resolve/';
}