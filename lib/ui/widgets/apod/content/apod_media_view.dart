import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:space_app/models/apod_item.dart';
import 'package:space_app/ui/widgets/feedback/app_snackbar.dart';
import 'package:space_app/utils/app_strings.dart';
import 'apod_fullscreen_viewer.dart';
import 'apod_media_overlays.dart';
import 'apod_media_placeholders.dart';

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

  void _handleTap(BuildContext context) {
    if (isVideo) {
      final link = videoUrl.isNotEmpty ? videoUrl : imageUrl;
      if (link.isNotEmpty) {
        Clipboard.setData(ClipboardData(text: link));
        AppSnackBar.showSuccess(
          context,
          AppStrings.videoLinkCopied,
          icon: Icons.link,
        );
      }
      return;
    }

    if (imageUrl.isEmpty) return;
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
      onTap: () => _handleTap(context),
      child: Stack(
        children: [
          _buildMediaImage(context),
          if (isVideo) const VideoPlayOverlay(),
          MediaTypeBadge(isVideo: isVideo),
          if (!isVideo && imageUrl.isNotEmpty) const ZoomHintBadge(),
        ],
      ),
    );
  }

  Widget _buildMediaImage(BuildContext context) {
    if (imageUrl.isEmpty) {
      return EmptyMediaPlaceholder(isVideo: isVideo);
    }

    return Image.network(
      imageUrl,
      height: 350,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : MediaLoadingPlaceholder(progress: progress),
      errorBuilder: (context, error, stackTrace) =>
          MediaErrorPlaceholder(isVideo: isVideo),
    );
  }
}
