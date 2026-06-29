import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/surah.dart';
import '../controllers/settings_controller.dart';
import '../controllers/bookmark_controller.dart';
import 'islamic_star_ornament.dart';

// Widget kartu untuk menampilkan informasi ayat lengkap (Arab, Latin, terjemahan, bookmark, dan audio)
class AyahCard extends StatelessWidget {
  final Ayat ayat;
  final bool isPlaying;
  final VoidCallback onPlayToggle;
  final int surahNo;
  final String surahName;

  const AyahCard({
    super.key,
    required this.ayat,
    required this.isPlaying,
    required this.onPlayToggle,
    required this.surahNo,
    required this.surahName,
  });

  // Membangun tampilan kartu ayat dengan respons dinamis terhadap kontrol tema dan bookmark
  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final accentColor = Theme.of(context).colorScheme.secondary;
    final settingsController = SettingsController();
    final bookmarkController = BookmarkController();

    return ListenableBuilder(
      listenable: settingsController,
      builder: (context, child) {
        final cardBgColor = Theme.of(context).cardColor;
        final textColor = Theme.of(context).brightness == Brightness.dark
            ? Colors.white70
            : Colors.black87;
        final italicColor = accentColor;

        return ListenableBuilder(
          listenable: bookmarkController,
          builder: (context, child) {
            final isBookmarked = bookmarkController.isBookmarked(surahNo, ayat.nomorAyat);
            final isLastRead = bookmarkController.lastReadSurahNo == surahNo &&
                bookmarkController.lastReadAyahNo == ayat.nomorAyat;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isPlaying
                      ? accentColor
                      : themeColor.withValues(alpha: 0.05),
                  width: isPlaying ? 1.5 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Row: Verse Number Star & Action Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Star Verse Number
                        IslamicStarOrnament(
                          number: ayat.nomorAyat.toString(),
                          color: accentColor,
                        ),
                        // Actions
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (ayat.audioUrl.isNotEmpty)
                              IconButton(
                                icon: Icon(
                                  isPlaying ? Icons.pause_circle : Icons.play_circle,
                                  color: themeColor,
                                  size: 24,
                                ),
                                onPressed: onPlayToggle,
                              ),
                            IconButton(
                              icon: Icon(
                                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                color: themeColor,
                                size: 22,
                              ),
                              onPressed: () {
                                bookmarkController.toggleBookmark(
                                  surahNo,
                                  surahName,
                                  ayat.nomorAyat,
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                isLastRead ? Icons.flag : Icons.flag_outlined,
                                color: isLastRead ? accentColor : themeColor,
                                size: 22,
                              ),
                              tooltip: 'Tandai Terakhir Dibaca',
                              onPressed: () {
                                bookmarkController.saveLastRead(
                                  surahNo,
                                  surahName,
                                  ayat.nomorAyat,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Terakhir Dibaca: QS. $surahName Ayat ${ayat.nomorAyat}',
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
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
                    // Latin Text (Italic Gold)
                    Text(
                      ayat.teksLatin,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                        fontSize: settingsController.translationFontSize,
                        color: italicColor,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Indonesian Translation
                    Text(
                      ayat.teksIndonesia,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                        fontSize: settingsController.translationFontSize,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
