import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/search_service.dart';
import '../controllers/surah_controller.dart';
import '../widgets/shimmer_loading.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchService _searchService = SearchService();
  final TextEditingController _queryController = TextEditingController();
  List<SearchMatch> _results = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _lastQuery = '';

  Future<void> _performSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _lastQuery = trimmed;
    });

    try {
      final res = await _searchService.searchAyah(trimmed);
      setState(() {
        _results = res;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _results = [];
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Widget _highlightText(String text, String query) {
    if (query.isEmpty) {
      return Text(
        text,
        style: GoogleFonts.poppins(fontSize: 13, height: 1.5),
      );
    }

    final String matches = query.toLowerCase();
    final String lowerText = text.toLowerCase();

    final List<TextSpan> spans = [];
    int start = 0;
    int index = lowerText.indexOf(matches);

    while (index != -1) {
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ));
      start = index + query.length;
      index = lowerText.indexOf(matches, start);
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        style: GoogleFonts.poppins(
          fontSize: 13,
          height: 1.5,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        children: spans,
      ),
    );
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
        title: TextField(
          controller: _queryController,
          autofocus: true,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: 'Cari kata di terjemahan...',
            hintStyle: GoogleFonts.poppins(color: Colors.white70, fontSize: 16),
            border: InputBorder.none,
            suffixIcon: _queryController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white70),
                    onPressed: () {
                      _queryController.clear();
                      setState(() {
                        _results = [];
                      });
                    },
                  )
                : null,
          ),
          onSubmitted: _performSearch,
        ),
      ),
      body: Column(
        children: [
          // Search Info Bar
          if (_lastQuery.isNotEmpty && !_isLoading && _errorMessage.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              width: double.infinity,
              color: themeColor.withValues(alpha: 0.05),
              child: Text(
                'Ditemukan ${_results.length} ayat untuk kata "$_lastQuery"',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final loadingCardColor = Theme.of(context).cardColor;

    if (_isLoading) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: loadingCardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoading(width: 140, height: 16),
                SizedBox(height: 12),
                ShimmerLoading(width: double.infinity, height: 12),
                SizedBox(height: 6),
                ShimmerLoading(width: 200, height: 12),
              ],
            ),
          );
        },
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 10),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_lastQuery.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 80,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
            ),
            const SizedBox(height: 16),
            Text(
              'Ketik kata kunci pencarian di atas\ndan tekan enter',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada ayat yang cocok ditemukan.',
          style: GoogleFonts.poppins(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final match = _results[index];

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
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                // Find complete Surah model from SurahController to open detail screen
                try {
                  final surah = SurahController().allSurah.firstWhere(
                        (s) => s.nomor == match.surahNumber,
                      );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        surah: surah,
                        initialAyahNo: match.numberInSurah,
                      ),
                    ),
                  );
                } catch (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Surat tidak ditemukan di daftar lokal'),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${match.surahEnglishName} • Ayat ${match.numberInSurah}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          match.surahName,
                          style: GoogleFonts.amiri(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _highlightText(match.text, _lastQuery),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
