import 'package:flutter/material.dart';
import 'package:space_app/models/apod_item.dart';
import 'apod_fullscreen_viewer.dart';

class ApodMediaView extends StatelessWidget {
  final String imageUrl;
  final String videoUrl;
  final String title;
  final bool isVideo;

  const ApodMediaView({
    super.key,
    required this.imageUrl,
    required this.videoUrl,
    required this.title,
    required this.isVideo,
  });

  ApodMediaView.item({
    super.key,
    required ApodItem item,
  })  : imageUrl = item.imageUrl,
        videoUrl = item.videoUrl ?? '',
        title = item.title,
        isVideo = item.isVideo;

  void _openFullscreen(BuildContext context) {
    if (isVideo || imageUrl.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(
          imageUrl: imageUrl,
          title: title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openFullscreen(context),
      child: Stack(
        children: [
          _buildMediaImage(context),
          if (isVideo) const _VideoPlayOverlay(),
          _buildTypeBadge(),
          if (!isVideo && imageUrl.isNotEmpty) const _ZoomHintBadge(),
        ],
      ),
    );
  }

  Widget _buildMediaImage(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _EmptyMediaPlaceholder(isVideo: isVideo);
    }

    return Image.network(
      imageUrl,
      height: 350,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : _MediaLoadingPlaceholder(progress: progress),
      errorBuilder: (context, error, stackTrace) =>
          _MediaErrorPlaceholder(isVideo: isVideo),
    );
  }

  Widget _buildTypeBadge() {
    final color = isVideo ? Colors.redAccent : Colors.lightBlueAccent;
    final icon = isVideo ? Icons.videocam : Icons.photo_camera;
    final label = isVideo ? "VIDEO" : "PHOTO";

    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoPlayOverlay extends StatelessWidget {
  const _VideoPlayOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withValues(alpha: 0.6),
              Colors.transparent,
              Colors.black.withValues(alpha: 0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white70, width: 2),
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              size: 48,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _ZoomHintBadge extends StatelessWidget {
  const _ZoomHintBadge();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.zoom_in, color: Colors.white70, size: 16),
            SizedBox(width: 4),
            Text(
              "Tap to zoom",
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MediaLoadingPlaceholder extends StatelessWidget {
  final ImageChunkEvent progress;

  const _MediaLoadingPlaceholder({required this.progress});

  @override
  Widget build(BuildContext context) {
    final total = progress.expectedTotalBytes;
    final loaded = progress.cumulativeBytesLoaded;
    final value = total != null ? loaded / total : null;

    return Container(
      height: 350,
      color: const Color(0xFF1E1E28),
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

class _MediaErrorPlaceholder extends StatelessWidget {
  final bool isVideo;

  const _MediaErrorPlaceholder({required this.isVideo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: double.infinity,
      color: const Color(0xFF1E1E28),
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

class _EmptyMediaPlaceholder extends StatelessWidget {
  final bool isVideo;

  const _EmptyMediaPlaceholder({required this.isVideo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: double.infinity,
      color: const Color(0xFF1E1E28),
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
