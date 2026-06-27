import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/audio_controller.dart';

class PersistentAudioPlayer extends StatelessWidget {
  const PersistentAudioPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final audioController = AudioController();
    final themeColor = Theme.of(context).primaryColor;
    final accentColor = Theme.of(context).colorScheme.secondary;

    return ListenableBuilder(
      listenable: audioController,
      builder: (context, child) {
        if (!audioController.isAnyAudioPlaying) {
          return const SizedBox.shrink();
        }

        final surahName = audioController.playingSurahName ?? '';
        final ayahNo = audioController.playingAyahNo;
        final trackTitle = ayahNo != null
            ? '$surahName: Ayat $ayahNo'
            : '$surahName (Murottal)';

        final durationMs = audioController.duration.inMilliseconds;
        final positionMs = audioController.position.inMilliseconds;
        final progressFactor = durationMs > 0 ? (positionMs / durationMs).clamp(0.0, 1.0) : 0.0;

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Gold progress indicator at the top
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.2),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: progressFactor,
                      child: Container(
                        decoration: BoxDecoration(
                          color: accentColor,
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withValues(alpha: 0.8),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                child: Row(
                  children: [
                    // Headphone Icon Container
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: themeColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.headphones,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Track Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            trackTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: themeColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Misyari Rasyid Al-Afasi',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Controls
                    IconButton(
                      icon: Icon(
                        Icons.stop,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                      onPressed: () => audioController.stop(),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: themeColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: themeColor.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          audioController.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () => audioController.togglePlayPause(),
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
