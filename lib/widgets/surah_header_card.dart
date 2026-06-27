import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/surah.dart';

class SurahHeaderCard extends StatelessWidget {
  final Surah surah;
  final SurahDetail? detail;
  final bool isAudioPlaying;
  final VoidCallback onAudioPlayToggle;

  const SurahHeaderCard({
    super.key,
    required this.surah,
    this.detail,
    required this.isAudioPlaying,
    required this.onAudioPlayToggle,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final accentColor = Theme.of(context).colorScheme.secondary;

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [themeColor, themeColor.withValues(alpha: 0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: themeColor.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Stack(
        children: [
          // Mosque ornament watermark
          Positioned(
            bottom: -30,
            right: -30,
            child: Icon(
              Icons.mosque,
              size: 140,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                surah.namaLatin,
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                surah.arti,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 16),
              // Bordered Metadata Row
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: Colors.white.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      surah.tempatTurun.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withValues(alpha: 0.9),
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${surah.jumlahAyat} VERSES',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withValues(alpha: 0.9),
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Play Full Surah Button
              if (surah.audioUrl.isNotEmpty)
                ElevatedButton(
                  onPressed: onAudioPlayToggle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.black87,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isAudioPlaying ? Icons.stop : Icons.play_arrow,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isAudioPlaying ? 'Stop Full Surah' : 'Play Full Surah',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
