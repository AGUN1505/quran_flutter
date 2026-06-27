import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/surah.dart';

class SurahHeaderCard extends StatelessWidget {
  final Surah surah;
  final SurahDetail? detail;
  final bool isAudioPlaying;
  final VoidCallback onAudioPlayToggle;
  final double shrinkProgress;

  const SurahHeaderCard({
    super.key,
    required this.surah,
    this.detail,
    required this.isAudioPlaying,
    required this.onAudioPlayToggle,
    this.shrinkProgress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final accentColor = Theme.of(context).colorScheme.secondary;

    // Interpolated values based on shrinkProgress
    final double paddingVertical = 28.0 - (18.0 * shrinkProgress); // 28.0 -> 10.0
    final double paddingHorizontal = 24.0 - (8.0 * shrinkProgress); // 24.0 -> 16.0
    final double marginValue = 16.0 - (8.0 * shrinkProgress); // 16.0 -> 8.0
    final double titleSize = 26.0 - (6.0 * shrinkProgress); // 26.0 -> 20.0

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      margin: EdgeInsets.all(marginValue),
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
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
          // Mosque ornament watermark (fades out as it shrinks)
          if (shrinkProgress < 0.8)
            Positioned(
              bottom: -30,
              right: -30,
              child: Opacity(
                opacity: ((1.0 - shrinkProgress) * 0.05).clamp(0.0, 0.05),
                child: Icon(
                  Icons.mosque,
                  size: 140,
                  color: Colors.white,
                ),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 100),
                style: GoogleFonts.poppins(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
                child: Text(surah.namaLatin),
              ),
              if (shrinkProgress < 0.5) ...[
                const SizedBox(height: 4),
                Opacity(
                  opacity: (1.0 - shrinkProgress * 2.0).clamp(0.0, 1.0),
                  child: Text(
                    surah.arti,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
              if (shrinkProgress < 0.7) ...[
                const SizedBox(height: 16),
                Opacity(
                  opacity: (1.0 - shrinkProgress * 1.43).clamp(0.0, 1.0),
                  child: Container(
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
                ),
              ],
              if (surah.audioUrl.isNotEmpty && shrinkProgress < 0.9) ...[
                const SizedBox(height: 20),
                Opacity(
                  opacity: (1.0 - shrinkProgress * 1.11).clamp(0.0, 1.0),
                  child: ElevatedButton(
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
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
