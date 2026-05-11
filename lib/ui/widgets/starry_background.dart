import 'dart:math';
import 'package:flutter/material.dart';

class StarryBackground extends StatelessWidget {
  final Widget child;
  const StarryBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: CustomPaint(painter: _StarryPainter())),
        child,
      ],
    );
  }
}

class _StarryPainter extends CustomPainter {
  final int starCount = 150;

  @override
  void paint(Canvas canvas, Size size) {
    final paintBackground = Paint()..color = const Color(0xFF1A1A20);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paintBackground,
    );

    final paintStar = Paint()..color = Colors.white.withOpacity(0.7);
    final random = Random(42);

    for (int i = 0; i < starCount; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.5 + 0.5;

      canvas.drawCircle(Offset(x, y), radius, paintStar);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
