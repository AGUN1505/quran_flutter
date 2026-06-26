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
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [themeColor, themeColor.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: themeColor.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${surah.tempatTurun.toUpperCase()} • ${surah.jumlahAyat} AYAT',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              if (surah.audioUrl.isNotEmpty)
                GestureDetector(
                  onTap: onAudioPlayToggle,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isAudioPlaying ? Icons.stop : Icons.play_arrow,
                          size: 16,
                          color: themeColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isAudioPlaying ? 'Stop Audio' : 'Putar Audio',
                          style: GoogleFonts.poppins(
                            color: themeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            detail?.nama ?? surah.nama,
            style: GoogleFonts.amiri(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            surah.arti,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const Divider(color: Colors.white24, height: 24),
          Text(
            (detail?.deskripsi ?? surah.deskripsi).replaceAll(RegExp(r'<[^>]*>'), ''),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.8),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
