import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/surah_controller.dart';
import '../screens/detail_screen.dart';

import '../widgets/shimmer_loading.dart';

// Panel Tab untuk menampilkan daftar Juz 1 sampai Juz 30 beserta pemetaan awal ayatnya
class JuzTab extends StatelessWidget {
  JuzTab({super.key});

  final SurahController _controller = SurahController();

  final List<Map<String, dynamic>> _juzList = [
    {'juz': 1, 'surahNo': 1, 'surahName': 'Al-Fatihah', 'ayahNo': 1},
    {'juz': 2, 'surahNo': 2, 'surahName': 'Al-Baqarah', 'ayahNo': 142},
    {'juz': 3, 'surahNo': 2, 'surahName': 'Al-Baqarah', 'ayahNo': 253},
    {'juz': 4, 'surahNo': 3, 'surahName': 'Ali \'Imran', 'ayahNo': 93},
    {'juz': 5, 'surahNo': 4, 'surahName': 'An-Nisa\'', 'ayahNo': 24},
    {'juz': 6, 'surahNo': 4, 'surahName': 'An-Nisa\'', 'ayahNo': 148},
    {'juz': 7, 'surahNo': 5, 'surahName': 'Al-Ma\'idah', 'ayahNo': 82},
    {'juz': 8, 'surahNo': 6, 'surahName': 'Al-An\'am', 'ayahNo': 111},
    {'juz': 9, 'surahNo': 7, 'surahName': 'Al-A\'raf', 'ayahNo': 88},
    {'juz': 10, 'surahNo': 8, 'surahName': 'Al-Anfal', 'ayahNo': 41},
    {'juz': 11, 'surahNo': 9, 'surahName': 'At-Taubah', 'ayahNo': 93},
    {'juz': 12, 'surahNo': 11, 'surahName': 'Hud', 'ayahNo': 6},
    {'juz': 13, 'surahNo': 12, 'surahName': 'Yusuf', 'ayahNo': 53},
    {'juz': 14, 'surahNo': 15, 'surahName': 'Al-Hijr', 'ayahNo': 1},
    {'juz': 15, 'surahNo': 17, 'surahName': 'Al-Isra\'', 'ayahNo': 1},
    {'juz': 16, 'surahNo': 18, 'surahName': 'Al-Kahf', 'ayahNo': 75},
    {'juz': 17, 'surahNo': 21, 'surahName': 'Al-Anbiya\'', 'ayahNo': 1},
    {'juz': 18, 'surahNo': 23, 'surahName': 'Al-Mu\'minun', 'ayahNo': 1},
    {'juz': 19, 'surahNo': 25, 'surahName': 'Al-Furqan', 'ayahNo': 21},
    {'juz': 20, 'surahNo': 27, 'surahName': 'An-Naml', 'ayahNo': 56},
    {'juz': 21, 'surahNo': 29, 'surahName': 'Al-\'Ankabut', 'ayahNo': 46},
    {'juz': 22, 'surahNo': 33, 'surahName': 'Al-Ahzab', 'ayahNo': 31},
    {'juz': 23, 'surahNo': 36, 'surahName': 'Yasin', 'ayahNo': 28},
    {'juz': 24, 'surahNo': 39, 'surahName': 'Az-Zumar', 'ayahNo': 32},
    {'juz': 25, 'surahNo': 41, 'surahName': 'Fussilat', 'ayahNo': 47},
    {'juz': 26, 'surahNo': 46, 'surahName': 'Al-Ahqaf', 'ayahNo': 1},
    {'juz': 27, 'surahNo': 51, 'surahName': 'Adz-Dzariyat', 'ayahNo': 31},
    {'juz': 28, 'surahNo': 58, 'surahName': 'Al-Mujadilah', 'ayahNo': 1},
    {'juz': 29, 'surahNo': 67, 'surahName': 'Al-Mulk', 'ayahNo': 1},
    {'juz': 30, 'surahNo': 78, 'surahName': 'An-Naba\'', 'ayahNo': 1},
  ];

  // Membangun tampilan daftar Juz dengan loading shimmer atau list item navigasi ke surat detail
  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        if (_controller.isLoading) {
          return ListView.builder(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 150),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    ShimmerLoading(
                      width: 40,
                      height: 40,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerLoading(width: 80, height: 16),
                          SizedBox(height: 8),
                          ShimmerLoading(width: 180, height: 12),
                        ],
                      ),
                    ),
                    ShimmerLoading(width: 16, height: 16),
                  ],
                ),
              );
            },
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 150),
          itemCount: _juzList.length,
          itemBuilder: (context, index) {
            final juz = _juzList[index];
            final int juzNo = juz['juz'];
            final int surahNo = juz['surahNo'];
            final String surahName = juz['surahName'];
            final int ayahNo = juz['ayahNo'];

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
                    child: Text(
                      juzNo.toString(),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  'Juz $juzNo',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  'Mulai dari QS. $surahName: Ayat $ayahNo',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: themeColor.withValues(alpha: 0.5),
                  size: 16,
                ),
                onTap: () {
                  try {
                    final surah = _controller.allSurah.firstWhere((s) => s.nomor == surahNo);
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
