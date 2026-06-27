import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/prayer_times_controller.dart';
import '../widgets/shimmer_loading.dart';

class SholatTab extends StatelessWidget {
  SholatTab({super.key});

  final PrayerTimesController _prayerTimesController = PrayerTimesController();

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return ListenableBuilder(
      listenable: _prayerTimesController,
      builder: (context, child) {
        if (_prayerTimesController.isLoading) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Dropdown card skeleton
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerLoading(width: 100, height: 12),
                        SizedBox(height: 8),
                        ShimmerLoading(width: 140, height: 24),
                      ],
                    ),
                    ShimmerLoading(width: 80, height: 14),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Timings rows skeletons
              ...List.generate(7, (index) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerLoading(width: 80, height: 16),
                    Row(
                      children: [
                        ShimmerLoading(width: 50, height: 16),
                        SizedBox(width: 8),
                        ShimmerLoading(width: 18, height: 18, borderRadius: BorderRadius.all(Radius.circular(9))),
                      ],
                    ),
                  ],
                ),
              )),
            ],
          );
        }

        if (_prayerTimesController.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 10),
                  Text(
                    _prayerTimesController.errorMessage,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _prayerTimesController.fetchPrayerTimes,
                    style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                    child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
        }

        final timings = _prayerTimesController.timings;
        if (timings == null) return const SizedBox.shrink();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Province & City Selector Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: themeColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'JADWAL SHOLAT',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        timings.dateReadable,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Provinsi Dropdown
                  Row(
                    children: [
                      Icon(Icons.map_outlined, color: Colors.white.withValues(alpha: 0.7), size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _prayerTimesController.selectedProvince,
                            dropdownColor: themeColor,
                            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            items: _prayerTimesController.provinces.map((prov) {
                              return DropdownMenuItem<String>(
                                value: prov,
                                child: Text(prov),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                _prayerTimesController.setProvince(val);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 16),
                  // Kabupaten/Kota Dropdown
                  Row(
                    children: [
                      Icon(Icons.location_city_outlined, color: Colors.white.withValues(alpha: 0.7), size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _prayerTimesController.selectedCity.isNotEmpty &&
                                    _prayerTimesController.cities.contains(_prayerTimesController.selectedCity)
                                ? _prayerTimesController.selectedCity
                                : (_prayerTimesController.cities.isNotEmpty ? _prayerTimesController.cities.first : null),
                            dropdownColor: themeColor,
                            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            items: _prayerTimesController.cities.map((city) {
                              return DropdownMenuItem<String>(
                                value: city,
                                child: Text(city),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                _prayerTimesController.setCity(val);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Timings list
            _buildTimingRow(context, 'Imsak', timings.imsak, themeColor),
            _buildTimingRow(context, 'Subuh', timings.subuh, themeColor),
            _buildTimingRow(context, 'Terbit (Syuruk)', timings.sunrise, themeColor),
            _buildTimingRow(context, 'Dhuha', timings.dhuha, themeColor),
            _buildTimingRow(context, 'Dzuhur', timings.dzuhur, themeColor),
            _buildTimingRow(context, 'Ashar', timings.ashar, themeColor),
            _buildTimingRow(context, 'Maghrib', timings.maghrib, themeColor),
            _buildTimingRow(context, 'Isya', timings.isya, themeColor),
          ],
        );
      },
    );
  }

  Widget _buildTimingRow(BuildContext context, String label, String time, Color themeColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Row(
            children: [
              Text(
                time,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: themeColor,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.access_time, color: themeColor.withValues(alpha: 0.4), size: 18),
            ],
          ),
        ],
      ),
    );
  }
}
