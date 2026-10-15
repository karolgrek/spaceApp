import 'package:flutter/material.dart';
import 'package:space_app/utils/app_colors.dart';

class MediaLoadingPlaceholder extends StatelessWidget {
  final ImageChunkEvent progress;

  const MediaLoadingPlaceholder({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final total = progress.expectedTotalBytes;
    final loaded = progress.cumulativeBytesLoaded;
    final value = total != null ? loaded / total : null;

    return Container(
      height: 350,
      color: AppColors.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              value: value,
              strokeWidth: 3,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              value != null
                  ? "Loading space imagery ${(value * 100).toInt()}%..."
                  : "Loading space imagery...",
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class MediaErrorPlaceholder extends StatelessWidget {
  final bool isVideo;

  const MediaErrorPlaceholder({super.key, required this.isVideo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: double.infinity,
      color: AppColors.background,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isVideo ? Icons.videocam_off : Icons.broken_image_outlined,
                size: 64,
                color: Colors.orangeAccent.withValues(alpha: 0.8),
              ),
              const SizedBox(height: 12),
              Text(
                isVideo ? "Video preview unavailable" : "Could not render image",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                isVideo
                    ? "The video thumbnail could not be loaded."
                    : "The media file could not be downloaded from NASA servers.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyMediaPlaceholder extends StatelessWidget {
  final bool isVideo;

  const EmptyMediaPlaceholder({super.key, required this.isVideo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: double.infinity,
      color: AppColors.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isVideo ? Icons.movie_creation_outlined : Icons.satellite_alt,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 12),
            Text(
              isVideo ? "Video of the Day" : "No image preview available",
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
