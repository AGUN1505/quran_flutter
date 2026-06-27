import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IslamicStarOrnament extends StatelessWidget {
  final String number;
  final Color color;

  const IslamicStarOrnament({
    super.key,
    required this.number,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer rotated square
        Transform.rotate(
          angle: 0.785398, // 45 degrees in radians
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              border: Border.all(
                color: color.withValues(alpha: 0.7),
                width: 1.8,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        // Inner square
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            border: Border.all(
              color: color.withValues(alpha: 0.7),
              width: 1.8,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        // Center number
        Text(
          number,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 11,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
