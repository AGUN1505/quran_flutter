import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/surah.dart';
import 'islamic_star_ornament.dart';

class SurahCard extends StatelessWidget {
  final Surah surah;
  final VoidCallback onTap;

  const SurahCard({
    super.key,
    required this.surah,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final accentColor = Theme.of(context).colorScheme.secondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: themeColor.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Star Number Ornament
                IslamicStarOrnament(
                  number: surah.nomor.toString(),
                  color: accentColor,
                ),
                const SizedBox(width: 16),
                // Surah Meta Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        surah.namaLatin,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: themeColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            surah.tempatTurun.toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.outlineVariant,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${surah.jumlahAyat} Ayat',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        surah.arti,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                // Arabic Script
                Text(
                  surah.nama,
                  style: GoogleFonts.amiri(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
