import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/surah.dart';
import '../controllers/surah_detail_controller.dart';
import '../controllers/audio_controller.dart';
import '../widgets/ayah_card.dart';
import '../widgets/surah_header_card.dart';
import '../widgets/persistent_audio_player.dart';
import 'tafsir_screen.dart';
import '../widgets/shimmer_loading.dart';

class DetailScreen extends StatefulWidget {
  final Surah surah;
  final int? initialAyahNo;

  const DetailScreen({
    super.key,
    required this.surah,
    this.initialAyahNo,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final SurahDetailController _detailController = SurahDetailController();
  final AudioController _audioController = AudioController();
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _ayahKeys = {};
  bool _hasScrolled = false;

  @override
  void initState() {
    super.initState();
    _detailController.fetchDetail(widget.surah.nomor);
  }

  @override
  void dispose() {
    _detailController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToAyah(List<Ayat> ayatList, int ayahNo) {
    final index = ayatList.indexWhere((a) => a.nomorAyat == ayahNo);
    if (index != -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 1. Approximate scroll to bring the target item into viewport to trigger rendering
        final double estimatedOffset = index * 220.0;
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(estimatedOffset.clamp(
            0.0,
            _scrollController.position.maxScrollExtent,
          ));
        }

        // 2. Wait for ListView.builder to render the item at the new offset, then align precisely
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final key = _ayahKeys[index];
          if (key != null && key.currentContext != null) {
            Scrollable.ensureVisible(
              key.currentContext!,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
        });
      });
    }
  }

  Future<void> _handleAyahPlay(String url, int index, int ayahNo) async {
    try {
      await _audioController.playAyah(
        url: url,
        index: index,
        surahNo: widget.surah.nomor,
        surahName: widget.surah.namaLatin,
        ayahNo: ayahNo,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memutar audio: $e')),
      );
    }
  }

  Future<void> _handleSurahPlay(String url) async {
    try {
      await _audioController.playSurahFull(
        url: url,
        surahNo: widget.surah.nomor,
        surahName: widget.surah.namaLatin,
      );
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
      body: Column(
        children: [
          Expanded(
            child: ListenableBuilder(
              listenable: _detailController,
              builder: (context, child) {
                if (_detailController.isLoading) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ShimmerLoading(
                                  width: 40,
                                  height: 40,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                Row(
                                  children: [
                                    ShimmerLoading(
                                      width: 24,
                                      height: 24,
                                      borderRadius: BorderRadius.all(Radius.circular(12)),
                                    ),
                                    SizedBox(width: 8),
                                    ShimmerLoading(
                                      width: 24,
                                      height: 24,
                                      borderRadius: BorderRadius.all(Radius.circular(12)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ShimmerLoading(width: 200, height: 24),
                            ),
                            SizedBox(height: 16),
                            ShimmerLoading(width: double.infinity, height: 14),
                            SizedBox(height: 8),
                            ShimmerLoading(width: 150, height: 14),
                          ],
                        ),
                      );
                    },
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
                            onPressed: () =>
                                _detailController.fetchDetail(widget.surah.nomor),
                            style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                            child: const Text('Coba Lagi',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final detail = _detailController.surahDetail;
                if (detail == null) return const SizedBox.shrink();

                // Trigger scroll to specific ayah if requested and not yet done
                if (widget.initialAyahNo != null && !_hasScrolled) {
                  _hasScrolled = true;
                  _scrollToAyah(detail.ayat, widget.initialAyahNo!);
                }

                final shouldShowBismillah = widget.surah.nomor != 1 && widget.surah.nomor != 9;

                return ListenableBuilder(
                  listenable: _audioController,
                  builder: (context, child) {
                    return Column(
                      children: [
                        // Surah Info Header Card Component
                        SurahHeaderCard(
                          surah: widget.surah,
                          detail: detail,
                          isAudioPlaying: _audioController.isSurahAudioPlaying &&
                              _audioController.playingSurahNo == widget.surah.nomor,
                          onAudioPlayToggle: () => _handleSurahPlay(widget.surah.audioUrl),
                        ),

                        // Ayah List Component
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: detail.ayat.length + (shouldShowBismillah ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (shouldShowBismillah && index == 0) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                    child: Text(
                                      'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                                      style: GoogleFonts.amiri(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: themeColor,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              final actualIndex = shouldShowBismillah ? index - 1 : index;
                              final ayat = detail.ayat[actualIndex];
                              final isPlaying =
                                  _audioController.playingAyahIndex == actualIndex &&
                                      _audioController.playingSurahNo == widget.surah.nomor;

                              return Container(
                                key: _ayahKeys.putIfAbsent(actualIndex, () => GlobalKey()),
                                child: AyahCard(
                                  ayat: ayat,
                                  isPlaying: isPlaying,
                                  onPlayToggle: () => _handleAyahPlay(
                                    ayat.audioUrl,
                                    actualIndex,
                                    ayat.nomorAyat,
                                  ),
                                  surahNo: widget.surah.nomor,
                                  surahName: widget.surah.namaLatin,
                                ),
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
          ),
          const PersistentAudioPlayer(),
        ],
      ),
    );
  }
}
