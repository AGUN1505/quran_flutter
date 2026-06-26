import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/surah.dart';
import '../controllers/settings_controller.dart';

class AyahCard extends StatelessWidget {
  final Ayat ayat;
  final bool isPlaying;
  final VoidCallback onPlayToggle;

  const AyahCard({
    super.key,
    required this.ayat,
    required this.isPlaying,
    required this.onPlayToggle,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final accentColor = Theme.of(context).colorScheme.secondary;
    final settingsController = SettingsController();

    return ListenableBuilder(
      listenable: settingsController,
      builder: (context, child) {
        final cardBgColor = Theme.of(context).cardColor;
        final textColor = Theme.of(context).brightness == Brightness.dark
            ? Colors.white70
            : Colors.black87;
        final italicColor = Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.secondary
            : themeColor;

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(15),
            border: isPlaying ? Border.all(color: accentColor, width: 1.5) : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Ayah Top Header (Number & Player Button)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.05),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: themeColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          ayat.nomorAyat.toString(),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (ayat.audioUrl.isNotEmpty)
                      IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                          color: themeColor,
                          size: 28,
                        ),
                        onPressed: onPlayToggle,
                      ),
                  ],
                ),
              ),

              // Ayah Content (Arabic, Latin, Indo)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Arabic Text
                    Text(
                      ayat.teksArab,
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.amiri(
                        fontSize: settingsController.arabicFontSize,
                        fontWeight: FontWeight.bold,
                        height: 2.0,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Latin Text (Align Left)
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        ayat.teksLatin,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: settingsController.translationFontSize,
                          color: italicColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Indo Text (Align Left)
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        ayat.teksIndonesia,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: settingsController.translationFontSize,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
