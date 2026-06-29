import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/settings_controller.dart';
import '../controllers/notification_settings_controller.dart';
import '../services/notification_service.dart';

// Halaman pengaturan aplikasi untuk mengonfigurasi tema, ukuran font teks, dan notifikasi sholat
class SettingsScreen extends StatelessWidget {
  final SettingsController settingsController;

  const SettingsScreen({
    super.key,
    required this.settingsController,
  });

  // Membangun antarmuka pengaturan dengan switch tema, slider ukuran teks, dan pengaturan adzan
  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pengaturan',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: settingsController,
        builder: (context, child) {
          final isDark = settingsController.isDarkMode;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Theme Section Header
              _buildSectionHeader(context, 'Tampilan'),

              // Theme Option Card
              Card(
                elevation: 0,
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.grey.withValues(alpha: 0.15)),
                ),
                child: SwitchListTile(
                  activeColor: themeColor,
                  title: Text(
                    'Mode Gelap',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    'Ubah tema aplikasi menjadi gelap',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  value: isDark,
                  onChanged: (value) => settingsController.toggleTheme(value),
                ),
              ),

              const SizedBox(height: 24),

              // Font Size Section Header
              _buildSectionHeader(context, 'Ukuran Font Arab'),

              // Arabic Font Size Card
              Card(
                elevation: 0,
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.grey.withValues(alpha: 0.15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ukuran Teks Arab',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${settingsController.arabicFontSize.toInt()} px',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: themeColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        activeColor: themeColor,
                        inactiveColor: themeColor.withValues(alpha: 0.2),
                        min: 20.0,
                        max: 40.0,
                        divisions: 10,
                        value: settingsController.arabicFontSize,
                        onChanged: (val) => settingsController.setArabicFontSize(val),
                      ),
                      const SizedBox(height: 12),
                      // Preview Box
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).disabledColor.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'بِسْمِ اللَّهِ',
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.amiri(
                            fontSize: settingsController.arabicFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Latin/Translation Font Size Section Header
              _buildSectionHeader(context, 'Ukuran Font Terjemahan & Latin'),

              // Translation Font Size Card
              Card(
                elevation: 0,
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.grey.withValues(alpha: 0.15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ukuran Teks Terjemahan',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${settingsController.translationFontSize.toInt()} px',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: themeColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        activeColor: themeColor,
                        inactiveColor: themeColor.withValues(alpha: 0.2),
                        min: 10.0,
                        max: 20.0,
                        divisions: 10,
                        value: settingsController.translationFontSize,
                        onChanged: (val) => settingsController.setTranslationFontSize(val),
                      ),
                      const SizedBox(height: 12),
                      // Preview Box
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).disabledColor.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.',
                          style: GoogleFonts.poppins(
                            fontSize: settingsController.translationFontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Notifikasi Waktu Sholat ──────────────────────────────────
              _buildSectionHeader(context, 'Notifikasi Waktu Sholat'),

              ListenableBuilder(
                listenable: NotificationSettingsController(),
                builder: (context, _) {
                  final nc = NotificationSettingsController();
                  final themeColor = Theme.of(context).primaryColor;

                  return Column(
                    children: [
                      // Global toggle
                      Card(
                        elevation: 0,
                        color: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.grey.withValues(alpha: 0.15)),
                        ),
                        child: SwitchListTile(
                          activeColor: themeColor,
                          secondary: Icon(Icons.notifications_active_rounded,
                              color: nc.globalEnabled ? themeColor : Colors.grey),
                          title: Text(
                            'Aktifkan Notifikasi',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          subtitle: Text(
                            'Terima pengingat di setiap waktu sholat',
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant),
                          ),
                          value: nc.globalEnabled,
                          onChanged: (val) async {
                            await nc.setGlobalEnabled(val);
                            // Reschedule agar perubahan langsung diterapkan
                            _rescheduleNotifications();
                          },
                        ),
                      ),

                      if (nc.globalEnabled) ...[
                        const SizedBox(height: 12),

                        // Per-prayer toggles
                        Card(
                          elevation: 0,
                          color: Theme.of(context).cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                                color: Colors.grey.withValues(alpha: 0.15)),
                          ),
                          child: Column(
                            children: [
                              _buildPrayerTile(
                                context: context,
                                icon: '🌙',
                                label: 'Imsak',
                                value: nc.imsakEnabled,
                                onChanged: (v) async {
                                  await nc.setImsakEnabled(v);
                                  _rescheduleNotifications();
                                },
                              ),
                              _buildDivider(),
                              _buildPrayerTile(
                                context: context,
                                icon: '🌅',
                                label: 'Subuh',
                                value: nc.subuhEnabled,
                                onChanged: (v) async {
                                  await nc.setSubuhEnabled(v);
                                  _rescheduleNotifications();
                                },
                              ),
                              _buildDivider(),
                              _buildPrayerTile(
                                context: context,
                                icon: '☀️',
                                label: 'Dzuhur',
                                value: nc.dzuhurEnabled,
                                onChanged: (v) async {
                                  await nc.setDzuhurEnabled(v);
                                  _rescheduleNotifications();
                                },
                              ),
                              _buildDivider(),
                              _buildPrayerTile(
                                context: context,
                                icon: '🌤️',
                                label: 'Ashar',
                                value: nc.asharEnabled,
                                onChanged: (v) async {
                                  await nc.setAsharEnabled(v);
                                  _rescheduleNotifications();
                                },
                              ),
                              _buildDivider(),
                              _buildPrayerTile(
                                context: context,
                                icon: '🌇',
                                label: 'Maghrib',
                                value: nc.maghribEnabled,
                                onChanged: (v) async {
                                  await nc.setMaghribEnabled(v);
                                  _rescheduleNotifications();
                                },
                              ),
                              _buildDivider(),
                              _buildPrayerTile(
                                context: context,
                                icon: '🌙',
                                label: 'Isya',
                                value: nc.isyaEnabled,
                                onChanged: (v) async {
                                  await nc.setIsyaEnabled(v);
                                  _rescheduleNotifications();
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Suara adzan picker
                        Card(
                          elevation: 0,
                          color: Theme.of(context).cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                                color: Colors.grey.withValues(alpha: 0.15)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.music_note_rounded,
                                        color: themeColor, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Suara Adzan',
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Radio buttons per suara
                                ...AdzanSound.values.map((sound) {
                                  return RadioListTile<AdzanSound>(
                                    activeColor: themeColor,
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    title: Text(
                                      sound.label,
                                      style: GoogleFonts.poppins(fontSize: 13),
                                    ),
                                    value: sound,
                                    groupValue: nc.selectedSound,
                                    onChanged: (val) async {
                                      if (val != null) {
                                        await nc.setSound(val);
                                        _rescheduleNotifications();
                                      }
                                    },
                                  );
                                }),
                                const SizedBox(height: 8),
                                // Tombol pratinjau suara
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: themeColor),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                    ),
                                    icon: Icon(Icons.play_circle_outline,
                                        color: themeColor),
                                    label: Text(
                                      'Pratinjau Suara',
                                      style: GoogleFonts.poppins(
                                          color: themeColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onPressed: () async {
                                      final granted =
                                          await NotificationService
                                              .requestPermissions();
                                      if (granted) {
                                        await NotificationService.playPreview(
                                            nc.selectedSound);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  /// Jadwalkan ulang notifikasi (dipanggil setiap ada perubahan setting)
  void _rescheduleNotifications() {
    // PrayerTimesController sudah menyimpan timings terbaru;
    // kita cukup memanggil NotificationService secara langsung jika ada timings.
    // Hal ini akan di-handle saat app dibuka berikutnya / fetch ulang jadwal.
    // Untuk reschedule instan, perlu akses ke PrayerTimesController.
    // Karena SettingsScreen adalah StatelessWidget, gunakan PrayerTimesController singleton:
    final ptc = _PrayerTimesControllerRef._instance;
    if (ptc != null) {
      NotificationService.schedulePrayerNotifications(
        ptc,
        NotificationSettingsController(),
      );
    }
  }

  // Widget pembantu untuk membangun item tile switch waktu sholat individu
  Widget _buildPrayerTile({
    required BuildContext context,
    required String icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final themeColor = Theme.of(context).primaryColor;
    return SwitchListTile(
      activeColor: themeColor,
      dense: true,
      secondary: Text(icon, style: const TextStyle(fontSize: 20)),
      title: Text(
        label,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 13),
      ),
      value: value,
      onChanged: onChanged,
    );
  }

  // Widget pembantu untuk membangun garis pembatas antar item menu
  Widget _buildDivider() => const Divider(height: 1, indent: 56, endIndent: 16);

  // Widget pembantu untuk membangun judul bagian menu pengaturan
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Kelas pembantu internal untuk menyimpan referensi global instansi PrayerTimesController
class _PrayerTimesControllerRef {
  static dynamic _instance;
}
