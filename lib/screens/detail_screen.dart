import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/surah.dart';
import '../controllers/surah_detail_controller.dart';
import '../controllers/audio_controller.dart';
import '../widgets/ayah_card.dart';
import '../widgets/surah_header_card.dart';
import 'tafsir_screen.dart';

class DetailScreen extends StatefulWidget {
  final Surah surah;
  const DetailScreen({super.key, required this.surah});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final SurahDetailController _detailController = SurahDetailController();
  final AudioController _audioController = AudioController();

  @override
  void initState() {
    super.initState();
    _detailController.fetchDetail(widget.surah.nomor);
  }

  @override
  void dispose() {
    _detailController.dispose();
    _audioController.dispose();
    super.dispose();
  }

  Future<void> _handleAyahPlay(String url, int index) async {
    try {
      await _audioController.playAyah(url, index);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memutar audio: $e')),
      );
    }
  }

  Future<void> _handleSurahPlay(String url) async {
    try {
      await _audioController.playSurahFull(url);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memutar audio full: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.surah.namaLatin,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book, color: Colors.white),
            tooltip: 'Lihat Tafsir',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TafsirScreen(surah: widget.surah),
                ),
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _detailController,
        builder: (context, child) {
          if (_detailController.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(themeColor),
              ),
            );
          }

          if (_detailController.errorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 10),
                    Text(
                      _detailController.errorMessage,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _detailController.fetchDetail(widget.surah.nomor),
                      style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                      child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }

          final detail = _detailController.surahDetail;
          if (detail == null) return const SizedBox.shrink();

          return ListenableBuilder(
            listenable: _audioController,
            builder: (context, child) {
              return Column(
                children: [
                  // Surah Info Header Card Component
                  SurahHeaderCard(
                    surah: widget.surah,
                    detail: detail,
                    isAudioPlaying: _audioController.isSurahAudioPlaying,
                    onAudioPlayToggle: () => _handleSurahPlay(widget.surah.audioUrl),
                  ),

                  // Ayah List Component
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: detail.ayat.length,
                      itemBuilder: (context, index) {
                        final ayat = detail.ayat[index];
                        final isPlaying = _audioController.playingAyahIndex == index;

                        return AyahCard(
                          ayat: ayat,
                          isPlaying: isPlaying,
                          onPlayToggle: () => _handleAyahPlay(ayat.audioUrl, index),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
