import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsController settingsController;

  const SettingsScreen({
    super.key,
    required this.settingsController,
  });

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
            ],
          );
        },
      ),
    );
  }

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
