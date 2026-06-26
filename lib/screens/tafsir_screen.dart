import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/surah.dart';
import '../controllers/tafsir_controller.dart';
import '../widgets/tafsir_card.dart';

class TafsirScreen extends StatefulWidget {
  final Surah surah;
  const TafsirScreen({super.key, required this.surah});

  @override
  State<TafsirScreen> createState() => _TafsirScreenState();
}

class _TafsirScreenState extends State<TafsirScreen> {
  final TafsirController _controller = TafsirController();

  @override
  void initState() {
    super.initState();
    _controller.fetchTafsir(widget.surah.nomor);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF7),
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tafsir ${widget.surah.namaLatin}',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(themeColor),
              ),
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
                      style: GoogleFonts.poppins(),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _controller.fetchTafsir(widget.surah.nomor),
                      style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                      child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }

          final detail = _controller.tafsirDetail;
          if (detail == null) return const SizedBox.shrink();

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: detail.tafsir.length,
            itemBuilder: (context, index) {
              final item = detail.tafsir[index];
              return TafsirCard(item: item);
            },
          );
        },
      ),
    );
  }
}
