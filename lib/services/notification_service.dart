import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import '../services/prayer_times_service.dart';
import '../controllers/notification_settings_controller.dart';

// Service untuk mengelola inisialisasi, perizinan, dan penjadwalan notifikasi waktu sholat (adzan) secara lokal
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  // Unique notification IDs per waktu sholat
  static const int _idImsak   = 0;
  static const int _idSubuh   = 1;
  static const int _idDzuhur  = 2;
  static const int _idAshar   = 3;
  static const int _idMaghrib = 4;
  static const int _idIsya    = 5;

  /// Inisialisasi plugin — dipanggil sekali di main()
  static Future<void> initialize() async {
    if (_initialized) return;
    try {
      tz.initializeTimeZones();

      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosInit = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      await _plugin.initialize(
        const InitializationSettings(android: androidInit, iOS: iosInit),
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      _initialized = true;
    } catch (e) {
      if (kDebugMode) debugPrint('NotificationService.initialize error: $e');
    }
  }

  // Callback internal yang dipicu ketika pengguna mengetuk notifikasi yang muncul
  static void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) debugPrint('Notification tapped: ${response.payload}');
  }

  /// Minta izin notifikasi (Android 13+ / iOS)
  static Future<bool> requestPermissions() async {
    try {
      final status = await Permission.notification.request();
      return status.isGranted;
    } catch (e) {
      if (kDebugMode) debugPrint('requestPermissions error: $e');
      return false;
    }
  }

  /// Buat AndroidNotificationChannel untuk jenis suara adzan
  static Future<void> _createChannels(AdzanSound sound) async {
    try {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
               AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin == null) return;

      AndroidNotificationSound? notifSound;
      if (sound.rawFileName != null) {
        notifSound = RawResourceAndroidNotificationSound(sound.rawFileName!);
      }

      final channel = AndroidNotificationChannel(
        sound.channelId,
        sound.channelName,
        description: 'Notifikasi pengingat waktu sholat',
        importance: Importance.high,
        sound: notifSound,
        enableVibration: true,
        playSound: true,
      );

      await androidPlugin.createNotificationChannel(channel);
    } catch (e) {
      if (kDebugMode) debugPrint('_createChannels error: $e');
    }
  }

  /// Jadwalkan ulang semua notifikasi waktu sholat hari ini
  static Future<void> schedulePrayerNotifications(
    PrayerTimings timings,
    NotificationSettingsController settings,
  ) async {
    if (!_initialized) {
      await initialize();
      if (!_initialized) return; // Jika masih gagal, berhenti
    }

    try {
      // Batalkan notifikasi lama satu per satu (lebih aman dari cancelAll)
      for (int i = 0; i <= 5; i++) {
        await _safeCancel(i);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Cancel old notifications error (ignored): $e');
    }

    // Jika notifikasi global dinonaktifkan, berhenti di sini
    if (!settings.globalEnabled) return;

    // Pastikan channel sudah dibuat
    await _createChannels(settings.selectedSound);

    final now = DateTime.now();

    final prayers = [
      (id: _idImsak,   label: 'Imsak',   time: timings.imsak,   enabled: settings.imsakEnabled,   emoji: '🌙'),
      (id: _idSubuh,   label: 'Subuh',   time: timings.subuh,   enabled: settings.subuhEnabled,   emoji: '🌅'),
      (id: _idDzuhur,  label: 'Dzuhur',  time: timings.dzuhur,  enabled: settings.dzuhurEnabled,  emoji: '☀️'),
      (id: _idAshar,   label: 'Ashar',   time: timings.ashar,   enabled: settings.asharEnabled,   emoji: '🌤️'),
      (id: _idMaghrib, label: 'Maghrib', time: timings.maghrib, enabled: settings.maghribEnabled, emoji: '🌇'),
      (id: _idIsya,    label: 'Isya',    time: timings.isya,    enabled: settings.isyaEnabled,    emoji: '🌙'),
    ];

    for (final prayer in prayers) {
      if (!prayer.enabled || prayer.time.isEmpty) continue;

      final scheduledTime = _parseTimeToday(prayer.time, now);
      if (scheduledTime == null) continue;
      if (scheduledTime.isBefore(now)) continue;

      await _safeSchedule(
        id: prayer.id,
        title: '${prayer.emoji} Waktu ${prayer.label}',
        body: 'Telah masuk waktu ${prayer.label} — ${prayer.time}',
        scheduledAt: scheduledTime,
        sound: settings.selectedSound,
      );

      if (kDebugMode) debugPrint('Scheduled ${prayer.label} at $scheduledTime');
    }
  }

  /// Cancel satu notifikasi, dengan penanganan error
  static Future<void> _safeCancel(int id) async {
    try {
      await _plugin.cancel(id);
    } catch (e) {
      if (kDebugMode) debugPrint('cancel($id) error (ignored): $e');
    }
  }

  /// Jadwalkan satu notifikasi dengan penanganan error
  static Future<void> _safeSchedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required AdzanSound sound,
  }) async {
    try {
      AndroidNotificationSound? notifSound;
      if (sound.rawFileName != null) {
        notifSound = RawResourceAndroidNotificationSound(sound.rawFileName!);
      }

      final androidDetails = AndroidNotificationDetails(
        sound.channelId,
        sound.channelName,
        channelDescription: 'Notifikasi pengingat waktu sholat',
        importance: Importance.high,
        priority: Priority.high,
        sound: notifSound,
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/ic_launcher',
        ticker: title,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final jakartaLocation = tz.getLocation('Asia/Jakarta');
      final tzScheduled = tz.TZDateTime.from(scheduledAt, jakartaLocation);

      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduled,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        // Tidak pakai matchDateTimeComponents agar tidak ada metadata repeat
        // yang disimpan di SharedPreferences (menghindari bug Kotlin type di v17)
      );
    } catch (e) {
      if (kDebugMode) debugPrint('_safeSchedule($id) error: $e');
    }
  }

  /// Batalkan semua notifikasi waktu sholat
  static Future<void> cancelAllNotifications() async {
    for (int i = 0; i <= 5; i++) {
      await _safeCancel(i);
    }
  }

  /// Pratinjau suara adzan — tampilkan notifikasi test sekarang
  static Future<void> playPreview(AdzanSound sound) async {
    if (!_initialized) await initialize();
    if (!_initialized) return;

    await _createChannels(sound);

    try {
      AndroidNotificationSound? notifSound;
      if (sound.rawFileName != null) {
        notifSound = RawResourceAndroidNotificationSound(sound.rawFileName!);
      }

      final androidDetails = AndroidNotificationDetails(
        sound.channelId,
        sound.channelName,
        channelDescription: 'Preview suara notifikasi',
        importance: Importance.high,
        priority: Priority.high,
        sound: notifSound,
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: false,
        presentSound: true,
      );

      await _plugin.show(
        99,
        '🔔 Preview: ${sound.label}',
        'Ini adalah pratinjau suara notifikasi adzan Anda.',
        NotificationDetails(android: androidDetails, iOS: iosDetails),
      );
    } catch (e) {
      if (kDebugMode) debugPrint('playPreview error: $e');
    }
  }

  /// Parse string "HH:mm" ke DateTime hari ini
  static DateTime? _parseTimeToday(String timeStr, DateTime now) {
    try {
      final parts = timeStr.trim().split(':');
      if (parts.length < 2) return null;
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (_) {
      return null;
    }
  }
}
