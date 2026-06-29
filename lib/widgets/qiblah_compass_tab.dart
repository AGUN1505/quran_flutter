import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';

// Widget Tab untuk menampilkan kompas arah kiblat interaktif berdasarkan lokasi GPS dan sensor perangkat
class QiblahCompassTab extends StatefulWidget {
  const QiblahCompassTab({super.key});

  @override
  State<QiblahCompassTab> createState() => _QiblahCompassTabState();
}

// State untuk QiblahCompassTab yang memproses perolehan lokasi GPS, perhitungan sudut Ka'bah, dan sensor magnetometer kompas
class _QiblahCompassTabState extends State<QiblahCompassTab> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  String _errorMessage = '';
  double? _qiblahDirection;
  double? _distanceToKaaba;
  
  // Kaaba Coordinates
  static const double _kaabaLat = 21.4225241;
  static const double _kaabaLng = 39.8261818;

  late final AnimationController _glowController;

  // Menginisialisasi controller animasi pendaran dan memulai kalkulasi parameter lokasi
  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _initLocationAndQiblah();
  }

  // Membersihkan resource controller animasi pendaran saat widget dibuang
  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  // Memeriksa izin akses lokasi, mendeteksi koordinat GPS, dan menghitung bearing arah kiblat serta jarak Ka'bah
  Future<void> _initLocationAndQiblah() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'Layanan lokasi (GPS) dinonaktifkan. Silakan aktifkan GPS perangkat Anda.';
          _isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Izin lokasi ditolak. Aplikasi membutuhkan akses lokasi untuk menentukan arah kiblat.';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'Izin lokasi ditolak secara permanen. Harap aktifkan izin lokasi di pengaturan aplikasi.';
          _isLoading = false;
        });
        return;
      }

      // Get current location
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      // Calculate Qiblah bearing
      final double bearing = _calculateQiblahBearing(position.latitude, position.longitude);
      
      // Calculate distance to Kaaba in Km
      final double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        _kaabaLat,
        _kaabaLng,
      );

      setState(() {
        _qiblahDirection = bearing;
        _distanceToKaaba = distanceInMeters / 1000.0;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal mendapatkan lokasi Anda: $e';
        _isLoading = false;
      });
    }
  }

  // Menghitung arah sudut kiblat menggunakan rumus bola trigonometri besar berdasarkan garis lintang dan bujur
  double _calculateQiblahBearing(double lat, double lng) {
    final double userLatRad = lat * math.pi / 180.0;
    final double userLngRad = lng * math.pi / 180.0;
    final double kaabaLatRad = _kaabaLat * math.pi / 180.0;
    final double kaabaLngRad = _kaabaLng * math.pi / 180.0;

    final double deltaLng = kaabaLngRad - userLngRad;

    final double y = math.sin(deltaLng);
    final double x = math.cos(userLatRad) * math.sin(kaabaLatRad) -
        math.sin(userLatRad) * math.cos(kaabaLatRad) * math.cos(deltaLng);

    final double bearingRad = math.atan2(y, x);
    final double bearingDeg = bearingRad * 180.0 / math.pi;

    return (bearingDeg + 360.0) % 360.0;
  }

  // Membangun antarmuka tampilan kompas kiblat interaktif beserta indikasi kecocokan sudut arah
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColor = Theme.of(context).primaryColor;
    
    // Glassmorphic translucent colors
    final cardBg = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.black.withValues(alpha: 0.03);
    final glassBorder = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : Colors.black.withValues(alpha: 0.10);

    return Scaffold(
      backgroundColor: Colors.transparent, // Background will be handled by HomeScreen
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 16.0, bottom: 150), // bottom padding for floating navbar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: themeColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: themeColor.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.explore, color: Colors.white, size: 28),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'KOMPAS KIBLAT',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            'Arahkan ponsel sejajar dengan tanah',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: glassBorder, width: 1.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: _buildMainContent(themeColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(Color themeColor) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              'Mendapatkan sinyal GPS lokasi...',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.location_off_outlined, size: 64, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _initLocationAndQiblah,
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: Text(
                'Coba Lagi',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error sensor kompas: ${snapshot.error}',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final double? heading = snapshot.data?.heading;

        if (heading == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.sensors_off_outlined, size: 64, color: Colors.orange),
                  const SizedBox(height: 16),
                  Text(
                    'Perangkat Anda tidak memiliki sensor arah (magnetometer) untuk kompas.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Qiblah Angle Relative to Device Heading
        final double qiblahAngle = _qiblahDirection != null
            ? (_qiblahDirection! - heading + 360.0) % 360.0
            : 0.0;

        // Is pointing directly to Kaaba? (tolerance 3.5 degrees)
        final bool isPointingToKaaba = qiblahAngle < 3.5 || qiblahAngle > 356.5;

        // Trigger brief vibration on alignment
        if (isPointingToKaaba) {
          HapticFeedback.lightImpact();
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final double size = math.min(constraints.maxWidth, constraints.maxHeight) * 0.75;
            final isDark = Theme.of(context).brightness == Brightness.dark;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Status Text
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isPointingToKaaba
                              ? Colors.amber.withValues(alpha: 0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isPointingToKaaba ? Colors.amber : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          isPointingToKaaba ? '✨ TEPAT ARAH KIBLAT ✨' : 'Putar ponsel Anda',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isPointingToKaaba
                                ? Colors.amber[700]
                                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Compass Display Stack
                      Center(
                        child: SizedBox(
                          width: size,
                          height: size,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Glowing Background Ring on Target
                              if (isPointingToKaaba)
                                AnimatedBuilder(
                                  animation: _glowController,
                                  builder: (context, child) {
                                    return Container(
                                      width: size * 0.98,
                                      height: size * 0.98,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.amber.withValues(alpha: 0.3 * _glowController.value),
                                            blurRadius: 20 + (10 * _glowController.value),
                                            spreadRadius: 2 + (4 * _glowController.value),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),

                              // Compass Dial (Rotates in the opposite direction of device heading)
                              Transform.rotate(
                                angle: (-heading * math.pi / 180.0),
                                child: _buildCompassDial(size, isDark, themeColor),
                              ),

                              // Static Needle or Center Target
                              _buildQiblahPointer(size, qiblahAngle, isPointingToKaaba, themeColor),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Info details (Distance and Bearing)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildDetailItem(
                            context,
                            'Jarak ke Ka\'bah',
                            '${_distanceToKaaba?.toStringAsFixed(1) ?? "0"} km',
                            Icons.location_on_outlined,
                            themeColor,
                          ),
                          _buildDetailItem(
                            context,
                            'Sudut Kiblat',
                            '${_qiblahDirection?.toStringAsFixed(1) ?? "0"}°',
                            Icons.explore_outlined,
                            themeColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Widget pembantu untuk menggambar dial bulat kompas dengan garis silang derajat
  Widget _buildCompassDial(double size, bool isDark, Color themeColor) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.black.withValues(alpha: 0.01),
        border: Border.all(
          color: themeColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Geometric background lines
          ...List.generate(8, (index) {
            final double angle = index * 45.0 * math.pi / 180.0;
            return Transform.rotate(
              angle: angle,
              child: Divider(
                color: themeColor.withValues(alpha: 0.1),
                thickness: 1,
                indent: 12,
                endIndent: 12,
              ),
            );
          }),
          // Ring
          Container(
            width: size * 0.75,
            height: size * 0.75,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: themeColor.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
          ),
          // Cardinal Directions (N, E, S, W)
          _buildDirectionText('U', 0.0, size, Colors.red[700]!),
          _buildDirectionText('T', 90.0, size, themeColor),
          _buildDirectionText('S', 180.0, size, themeColor),
          _buildDirectionText('B', 270.0, size, themeColor),
        ],
      ),
    );
  }

  // Widget pembantu untuk meletakkan teks arah mata angin (U, S, T, B) di tepian dial kompas
  Widget _buildDirectionText(String text, double angleDegrees, double size, Color color) {
    final double angleRad = angleDegrees * math.pi / 180.0;
    final double radius = size * 0.40;
    final double x = radius * math.sin(angleRad);
    final double y = -radius * math.cos(angleRad);

    return Transform.translate(
      offset: Offset(x, y),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: color,
        ),
      ),
    );
  }

  // Widget pembantu untuk membangun jarum penunjuk arah kiblat yang menunjuk ke lambang Ka'bah
  Widget _buildQiblahPointer(double size, double qiblahAngleRad, bool isPointing, Color themeColor) {
    // Needle size
    final double needleLength = size * 0.32;
    
    return Transform.rotate(
      angle: qiblahAngleRad * math.pi / 180.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glowing center circle
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isPointing ? Colors.amber : themeColor,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: (isPointing ? Colors.amber : themeColor).withValues(alpha: 0.5),
                  blurRadius: 8,
                )
              ],
            ),
          ),
          
          // Glowing Pointer Arrow
          Transform.translate(
            offset: Offset(0, -needleLength / 2),
            child: Container(
              width: 8,
              height: needleLength,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: isPointing
                      ? [Colors.amber.withValues(alpha: 0.1), Colors.amber]
                      : [themeColor.withValues(alpha: 0.1), themeColor],
                ),
              ),
            ),
          ),

          // Kaaba Icon at the tip of the arrow
          Transform.translate(
            offset: Offset(0, -needleLength - 6),
            child: Transform.rotate(
              angle: -qiblahAngleRad * math.pi / 180.0, // Keep icon upright
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isPointing ? Colors.amber : themeColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 6,
                    )
                  ],
                ),
                child: const Icon(
                  Icons.mosque,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget pembantu untuk menampilkan item kotak detail (jarak ke Ka'bah atau derajat sudut kiblat)
  Widget _buildDetailItem(BuildContext context, String title, String value, IconData icon, Color themeColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeColor.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: themeColor, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
