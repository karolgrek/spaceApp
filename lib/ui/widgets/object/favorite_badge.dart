import 'package:flutter/material.dart';

class FavoriteBadge extends StatelessWidget {
  final double size;
  final EdgeInsetsGeometry padding;

  const FavoriteBadge({
    super.key,
    this.size = 14,
    this.padding = const EdgeInsets.all(4),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.favorite,
        color: Colors.redAccent,
        size: size,
      ),
    );
  }
}
