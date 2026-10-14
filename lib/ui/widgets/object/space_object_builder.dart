import 'dart:io';
import 'package:flutter/material.dart';

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
      String path = imagePath;
      if (path == 'assets/images/black_hole.png') {
        path = 'assets/images/blackhole.png';
      }

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
    IconData icon;
    switch (category) {
      case 'Planet':
        icon = Icons.public;
        break;
      case 'Star':
        icon = Icons.star;
        break;
      case 'Galaxy':
        icon = Icons.blur_circular;
        break;
      case 'Comet':
        icon = Icons.flash_on;
        break;
      case 'Black Hole':
        icon = Icons.brightness_1;
        break;
      case 'Moon':
        icon = Icons.nightlight_round;
        break;
      case 'Satellite':
        icon = Icons.satellite_alt;
        break;
      default:
        icon = Icons.auto_awesome;
    }

    return Container(
      color: Colors.deepPurple[900],
      child: Center(
        child: Icon(icon, size: 50, color: Colors.white70),
      ),
    );
  }
}
