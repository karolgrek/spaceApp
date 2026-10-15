import 'dart:io';
import 'package:flutter/material.dart';
import 'package:space_app/utils/app_constants.dart';

class SpaceObjectImage extends StatelessWidget {
  final String imagePath;
  final String category;

  const SpaceObjectImage({
    super.key,
    required this.imagePath,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath.isNotEmpty) {
      final path = imagePath;

      if (path.startsWith('assets/')) {
        return Image.asset(
          path,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        );
      } else if (path.startsWith('http://') ||
          path.startsWith('https://')) {
        return Image.network(
          path,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        );
      } else {
        return Image.file(
          File(path),
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        );
      }
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    final icon = AppConstants.getCategoryIcon(category);

    return Container(
      color: Colors.deepPurple[900],
      child: Center(
        child: Icon(icon, size: 50, color: Colors.white70),
      ),
    );
  }
}
