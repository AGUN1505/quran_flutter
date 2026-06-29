import 'package:flutter/material.dart';

// Widget untuk menampilkan efek kerangka memuat data (shimmer skeleton loading effect)
class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

// State untuk ShimmerLoading yang mengelola kontrol siklus hidup animasi transisi gradien geser
class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Menginisialisasi controller dan tween animasi perulangan transisi geser gradien
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -2.0, end: 2.0).animate(_controller);
  }

  // Membersihkan resource controller animasi shimmer saat widget dibuang
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Membangun tampilan kontainer gradien linear abu-abu yang bergeser secara dinamis
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark
        ? const [
            Color(0xFF2C2C2C),
            Color(0xFF3A3A3A),
            Color(0xFF2C2C2C),
          ]
        : const [
            Color(0xFFEBEBEB),
            Color(0xFFF4F4F4),
            Color(0xFFEBEBEB),
          ];

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
              stops: const [0.0, 0.5, 1.0],
              transform: _SlidingGradientTransform(slidePercent: _animation.value),
            ),
          ),
        );
      },
    );
  }
}

// Kelas pembantu internal untuk menggeser matriks posisi gradien linear linear secara horizontal
class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({
    required this.slidePercent,
  });

  final double slidePercent;

  // Menghitung matriks transformasi pergeseran gradien linear berdasarkan presentasi geser
  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}
