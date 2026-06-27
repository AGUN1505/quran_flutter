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

    // Title and meaning disappear
    final double titleOpacity = (1.0 - shrinkProgress * 1.5).clamp(0.0, 1.0);
    final double titleHeight = 36.0 * (1.0 - shrinkProgress); // collapse height
    
    final double meaningOpacity = (1.0 - shrinkProgress * 2.0).clamp(0.0, 1.0);
    final double meaningHeight = 20.0 * (1.0 - shrinkProgress); // collapse height

    // Spacers collapse
    final double spacer1Height = 4.0 * (1.0 - shrinkProgress);
    final double spacer2Height = 16.0 * (1.0 - shrinkProgress);
    final double spacer3Height = 20.0 - (10.0 * shrinkProgress); // 20.0 -> 10.0

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
              // Title Container
              if (titleOpacity > 0.0)
                Opacity(
                  opacity: titleOpacity,
                  child: SizedBox(
                    height: titleHeight,
                    child: Center(
                      child: Text(
                        surah.namaLatin,
                        style: GoogleFonts.poppins(
                          fontSize: 26.0 * (1.0 - shrinkProgress * 0.3), // shrink font size slightly
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              if (titleOpacity > 0.0) SizedBox(height: spacer1Height),
              
              // Meaning Container
              if (meaningOpacity > 0.0)
                Opacity(
                  opacity: meaningOpacity,
                  child: SizedBox(
                    height: meaningHeight,
                    child: Center(
                      child: Text(
                        surah.arti,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ),
                ),
              if (meaningOpacity > 0.0) SizedBox(height: spacer2Height),

              // City & Verses Container (Always visible!)
              Container(
                padding: EdgeInsets.symmetric(vertical: 10 - (4.0 * shrinkProgress)), // make it more compact when scrolled
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: Colors.white.withValues(alpha: 0.15 * (1.0 - shrinkProgress * 0.4)),
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
                        fontSize: 11 - (1.0 * shrinkProgress), // 11 -> 10
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
                        fontSize: 11 - (1.0 * shrinkProgress), // 11 -> 10
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withValues(alpha: 0.9),
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: spacer3Height),

              // Play Full Surah Button (Always visible!)
              if (surah.audioUrl.isNotEmpty)
                ElevatedButton(
                  onPressed: onAudioPlayToggle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.black87,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24 - (6.0 * shrinkProgress), // 24 -> 18
                      vertical: 12 - (4.0 * shrinkProgress), // 12 -> 8
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isAudioPlaying ? Icons.stop : Icons.play_arrow,
                        size: 20 - (2.0 * shrinkProgress), // 20 -> 18
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isAudioPlaying ? 'Stop Full Surah' : 'Play Full Surah',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 13 - (1.0 * shrinkProgress), // 13 -> 12
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
