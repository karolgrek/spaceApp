import 'dart:math';
import 'package:flutter/material.dart';

class StarryBackground extends StatelessWidget {
  final Widget child;

  const StarryBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: StarPainter(),
          child: Container(),
        ),
        child,
      ],
    );
  }
}

class StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42);
    final paintStar = Paint()..color = Colors.white.withValues(alpha: 0.7);

    for (int i = 0; i < 150; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.8 + 0.5;

      canvas.drawCircle(Offset(x, y), radius, paintStar);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
