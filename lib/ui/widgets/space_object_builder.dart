import 'package:flutter/material.dart';
import 'dart:io';

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
      final file = File(imagePath);
      if (file.existsSync()) {
        return Image.file(file, width: double.infinity, fit: BoxFit.cover);
      }
    }
    String assetPath;
    switch (category) {
      case 'Planet':
        assetPath = 'assets/images/planet.png';
        break;
      case 'Star':
        assetPath = 'assets/images/star.png';
        break;
      case 'Galaxy':
        assetPath = 'assets/images/galaxy.png';
        break;
      case 'Comet':
        assetPath = 'assets/images/comet.png';
        break;
      case 'Black Hole':
        assetPath = 'assets/images/blackhole.png';
        break;
      case 'Moon':
        assetPath = 'assets/images/moon.png';
        break;
      case 'Satellite':
        assetPath = 'assets/images/satellite.png';
        break;
      default:
        return Container(
          color: Colors.grey[800],
          child: const Icon(
            Icons.image_not_supported_outlined,
            size: 40,
            color: Colors.grey,
          ),
        );
    }

    return Image.asset(
      assetPath,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[800],
          child: const Icon(
            Icons.image_not_supported_outlined,
            size: 40,
            color: Colors.grey,
          ),
        );
      },
    );
  }
}
