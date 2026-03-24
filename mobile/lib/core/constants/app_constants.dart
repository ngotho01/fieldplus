class AppConstants {
  AppConstants._();

  static const String appName = 'FieldPulse';

  // Secure storage keys
  static const String accessTokenKey  = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey         = 'current_user';
  static const String fcmTokenKey     = 'fcm_token';
  static const String biometricEnabledKey = 'biometric_enabled';

  // Sync
  static const int maxSyncRetries   = 3;
  static const int syncBatchSize    = 20;

  // Image
  static const int imageMaxDimension = 1200;
  static const int imageQuality      = 80;

  // Pagination
  static const int pageSize = 20;

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}