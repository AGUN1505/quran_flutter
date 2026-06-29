import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/surah_controller.dart';
import '../widgets/surah_card.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/last_read_banner.dart';
import '../screens/detail_screen.dart';

// Widget Tab untuk menampilkan daftar surat lengkap (1-114) dan bilah pencarian lokal
class SuratTab extends StatefulWidget {
  const SuratTab({super.key});

  @override
  State<SuratTab> createState() => _SuratTabState();
}

// State untuk SuratTab yang menangani pencarian lokal dan pemuatan awal daftar surat
class _SuratTabState extends State<SuratTab> {
  final SurahController _controller = SurahController();
  final TextEditingController _searchController = TextEditingController();

  // Menginisialisasi state dan memicu penarikan data surat jika daftar lokal kosong
  @override
  void initState() {
    super.initState();
    if (_controller.allSurah.isEmpty) {
      _controller.fetchSurahList();
    }
  }

  // Membersihkan resource TextEditingController saat widget dibuang
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Membangun tampilan tab surat dengan banner riwayat bacaan, kolom pencarian, dan daftar surat
  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Column(
      children: [
        const LastReadBanner(),
        // Local Surah Filter Search Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _controller.filterSearch,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Cari nama surat...',
                hintStyle: GoogleFonts.poppins(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                prefixIcon: Icon(Icons.search, color: themeColor),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListenableBuilder(
            listenable: _controller,
            builder: (context, child) {
              if (_controller.isLoading) {
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 150),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          const ShimmerLoading(
                            width: 40,
                            height: 40,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShimmerLoading(width: 120, height: 16),
                                SizedBox(height: 8),
                                ShimmerLoading(width: 80, height: 12),
                              ],
                            ),
                          ),
                          const ShimmerLoading(width: 50, height: 24),
                        ],
                      ),
                    );
                  },
                );
              }

              if (_controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 60, color: Colors.red),
                        const SizedBox(height: 10),
                        Text(
                          _controller.errorMessage,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _controller.fetchSurahList,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Coba Lagi',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (_controller.filteredSurah.isEmpty) {
                return Center(
                  child: Text(
                    'Surat tidak ditemukan.',
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 16,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 150),
                itemCount: _controller.filteredSurah.length,
                itemBuilder: (context, index) {
                  final surah = _controller.filteredSurah[index];
                  return SurahCard(
                    surah: surah,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(surah: surah),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
