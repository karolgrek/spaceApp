import 'package:flutter/material.dart';

class VideoPlayOverlay extends StatelessWidget {
  const VideoPlayOverlay({super.key});

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

class ZoomHintBadge extends StatelessWidget {
  const ZoomHintBadge({super.key});

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

class MediaTypeBadge extends StatelessWidget {
  final bool isVideo;

  const MediaTypeBadge({super.key, required this.isVideo});

  @override
  Widget build(BuildContext context) {
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
