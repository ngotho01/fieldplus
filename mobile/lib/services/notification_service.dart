import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/constants/app_constants.dart';
import '../core/constants/api_constants.dart';
import '../core/network/dio_client.dart';

// ── Background handler — must be top-level function ───────────────────────────
@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationService.showLocalNotification(message);
}

// ── Channel constants ─────────────────────────────────────────────────────────
const _channelId   = 'fieldpulse_jobs';
const _channelName = 'Job Assignments';
const _channelDesc = 'Notifications for new job assignments and updates';

class NotificationService {
  NotificationService._();

  static final _local = FlutterLocalNotificationsPlugin();
  static final _fcm   = FirebaseMessaging.instance;

  // Holds the job_id from a notification tap (used for deep-link on cold start)
  static String? pendingJobId;

  static Future<void> initialize() async {
    // 1. Request permission
    final settings = await _fcm.requestPermission(
      alert:       true,
      badge:       true,
      sound:       true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) return;

    // 2. Create Android notification channel
    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance:  Importance.high,
    );

    await _local
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // 3. Init flutter_local_notifications
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit     = DarwinInitializationSettings(
      requestAlertPermission: false, // already requested above
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _local.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: (response) {
        // Notification tapped while app is in foreground or background
        if (response.payload != null) {
          pendingJobId = response.payload;
        }
      },
    );

    // 4. Register background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

    // 5. Foreground messages — show as local notification
    FirebaseMessaging.onMessage.listen((message) {
      showLocalNotification(message);
    });

    // 6. App opened from background via notification tap
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final jobId = message.data['job_id'] as String?;
      if (jobId != null) pendingJobId = jobId;
    });

    // 7. App opened from terminated state via notification tap
    final initial = await _fcm.getInitialMessage();
    if (initial != null) {
      pendingJobId = initial.data['job_id'] as String?;
    }

    // 8. Register FCM token with backend
    await _registerToken();

    // 9. Listen for token refresh
    _fcm.onTokenRefresh.listen(_uploadToken);
  }

  static Future<void> showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority:   Priority.high,
      icon:       '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails();

    await _local.show(
      message.hashCode,
      notification.title ?? 'FieldPulse',
      notification.body  ?? '',
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: message.data['job_id'] as String?,
    );
  }

  static Future<void> _registerToken() async {
    try {
      final token = await _fcm.getToken();
      if (token != null) await _uploadToken(token);
    } catch (_) {
      // Silently ignore — will retry on next launch
    }
  }

  static Future<void> _uploadToken(String token) async {
    try {
      // Store token locally so DioClient can read it
      const storage = FlutterSecureStorage();
      await storage.write(key: AppConstants.fcmTokenKey, value: token);

      // Upload to backend if we have a session
      final accessToken = await storage.read(key: AppConstants.accessTokenKey);
      if (accessToken == null) return;

      await DioClient.instance.post(
        ApiConstants.fcmRegister,
        data: {'token': token},
      );
    } catch (_) {}
  }

  static Future<String?> getToken() => _fcm.getToken();
}