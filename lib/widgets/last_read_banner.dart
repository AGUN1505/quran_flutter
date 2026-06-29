import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/bookmark_controller.dart';
import '../controllers/surah_controller.dart';
import '../screens/detail_screen.dart';

// Widget banner yang menampilkan riwayat ayat terakhir yang dibaca pengguna dan tombol untuk melanjutkannya
class LastReadBanner extends StatelessWidget {
  const LastReadBanner({super.key});

  // Membangun tampilan banner secara dinamis berdasarkan status bacaan terakhir di BookmarkController
  @override
  Widget build(BuildContext context) {
    final bookmarkController = BookmarkController();
    final surahController = SurahController();
    final themeColor = Theme.of(context).primaryColor;
    final accentColor = Theme.of(context).colorScheme.secondary;

    return ListenableBuilder(
      listenable: bookmarkController,
      builder: (context, child) {
        if (!bookmarkController.hasLastRead) return const SizedBox.shrink();

        final surahNo = bookmarkController.lastReadSurahNo!;
        final surahName = bookmarkController.lastReadSurahName ?? '';
        final ayahNo = bookmarkController.lastReadAyahNo!;

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [themeColor, themeColor.withValues(alpha: 0.85)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: themeColor.withValues(alpha: 0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Mosque background ornament simulation (subtle icon in bottom corner)
              Positioned(
                bottom: -20,
                right: -20,
                child: Icon(
                  Icons.mosque,
                  size: 120,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.menu_book,
                          color: accentColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'TERAKHIR DIBACA',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'QS. $surahName: Ayat $ayahNo',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ketuk untuk melanjutkan bacaan Anda',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        try {
                          final surah = surahController.allSurah.firstWhere((s) => s.nomor == surahNo);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                surah: surah,
                                initialAyahNo: ayahNo,
                              ),
                            ),
                          );
                        } catch (_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Detail surat tidak dapat dimuat.')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Lanjutkan Membaca',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward, size: 16),
                        ],
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
