import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/bookmark_controller.dart';
import '../controllers/surah_controller.dart';
import '../screens/detail_screen.dart';

// Panel Tab untuk menampilkan daftar ayat-ayat Al-Quran yang telah di-bookmark oleh pengguna
class BookmarkTab extends StatelessWidget {
  BookmarkTab({super.key});

  final BookmarkController _bookmarkController = BookmarkController();
  final SurahController _surahController = SurahController();

  // Menampilkan dialog konfirmasi sebelum menghapus ayat dari daftar bookmark
  void _showDeleteConfirmation(BuildContext context, String surahName, int surahNo, int ayahNo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final themeColor = Theme.of(context).primaryColor;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.amber,
                size: 28,
              ),
              const SizedBox(width: 10),
              Text(
                'Hapus Bookmark?',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus bookmark untuk QS. $surahName Ayat $ayahNo?',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _bookmarkController.toggleBookmark(surahNo, surahName, ayahNo);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Bookmark QS. $surahName Ayat $ayahNo berhasil dihapus',
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: themeColor,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Hapus',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Membangun tampilan daftar bookmark atau pesan kosong jika tidak ada bookmark
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
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 150),
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
                  onPressed: () => _showDeleteConfirmation(context, b.surahName, b.surahNo, b.ayahNo),
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
