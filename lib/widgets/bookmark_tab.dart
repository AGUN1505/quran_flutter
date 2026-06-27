import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/bookmark_controller.dart';
import '../controllers/surah_controller.dart';
import '../screens/detail_screen.dart';

class BookmarkTab extends StatelessWidget {
  BookmarkTab({super.key});

  final BookmarkController _bookmarkController = BookmarkController();
  final SurahController _surahController = SurahController();

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return ListenableBuilder(
      listenable: _bookmarkController,
      builder: (context, child) {
        final bookmarks = _bookmarkController.bookmarks;

        if (bookmarks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bookmark_border,
                  size: 80,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada bookmark ayat.',
                  style: GoogleFonts.poppins(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookmarks.length,
          itemBuilder: (context, index) {
            final b = bookmarks[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: themeColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(Icons.bookmark, color: themeColor, size: 20),
                  ),
                ),
                title: Text(
                  'QS. ${b.surahName}: Ayat ${b.ayahNo}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  'Ketuk untuk membaca ayat ini',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    _bookmarkController.toggleBookmark(
                      b.surahNo,
                      b.surahName,
                      b.ayahNo,
                    );
                  },
                ),
                onTap: () {
                  try {
                    final surah =
                        _surahController.allSurah.firstWhere((s) => s.nomor == b.surahNo);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          surah: surah,
                          initialAyahNo: b.ayahNo,
                        ),
                      ),
                    );
                  } catch (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Surat tidak ditemukan lokal')),
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
