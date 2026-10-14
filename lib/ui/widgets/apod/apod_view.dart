import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:space_app/providers/daily_picture_provider.dart';

class ApodContentView extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isCached;
  final String? cacheReason;
  final VoidCallback? onRetryOnline;

  const ApodContentView({
    super.key,
    required this.data,
    this.isCached = false,
    this.cacheReason,
    this.onRetryOnline,
  });

  @override
  Widget build(BuildContext context) {
    final mediaType = data['media_type']?.toString().toLowerCase();
    final isVideo = mediaType == 'video';
    final imageUrl = (isVideo ? data['thumbnail_url'] : data['url'])?.toString() ??
        data['url']?.toString() ??
        '';
    final videoUrl = data['url']?.toString() ?? '';
    final title = data['title']?.toString() ?? 'Astronomy Picture of the Day';
    final explanation = data['explanation']?.toString() ?? 'No explanation provided.';
    final date = data['date']?.toString();
    final copyright = data['copyright']?.toString().replaceAll('\n', ' ').trim();
    final hdUrl = data['hdurl']?.toString();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner for cached / offline mode
          if (isCached)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.history_toggle_off, color: Colors.amberAccent, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Offline Mode \u2022 Showing Saved Picture${date != null ? ' ($date)' : ''}",
                          style: const TextStyle(
                            color: Colors.amberAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        if (cacheReason != null && cacheReason!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              cacheReason!,
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (onRetryOnline != null)
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.amberAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text("Retry"),
                      onPressed: onRetryOnline,
                    ),
                ],
              ),
            ),

          // Media display area (Image or Video Thumbnail)
          Stack(
            children: [
              if (imageUrl.isNotEmpty)
                Image.network(
                  imageUrl,
                  height: 350,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    final totalBytes = loadingProgress.expectedTotalBytes;
                    final loadedBytes = loadingProgress.cumulativeBytesLoaded;
                    final progress =
                        totalBytes != null ? loadedBytes / totalBytes : null;

                    return Container(
                      height: 350,
                      color: const Color(0xFF1E1E28),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 3,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              progress != null
                                  ? "Loading space imagery ${(progress * 100).toInt()}%..."
                                  : "Loading space imagery...",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
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
                              isVideo
                                  ? "Video preview unavailable"
                                  : "Could not render image",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
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
                  ),
                )
              else
                Container(
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
                ),

              // Overlay for video
              if (isVideo)
                Positioned.fill(
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
                ),

              // Media type badge
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isVideo ? Colors.redAccent : Colors.lightBlueAccent,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isVideo ? Icons.videocam : Icons.photo_camera,
                        size: 14,
                        color: isVideo ? Colors.redAccent : Colors.lightBlueAccent,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isVideo ? "VIDEO" : "PHOTO",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isVideo ? Colors.redAccent : Colors.lightBlueAccent,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Video action bar if APOD is a video
          if (isVideo && videoUrl.isNotEmpty)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A35),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.ondemand_video, color: Colors.redAccent, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Today's APOD is a Video",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          videoUrl,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    tooltip: "Copy video link",
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: videoUrl));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Video link copied to clipboard!"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

          // Content section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 10),

                // Metadata row (Date, Copyright)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (date != null && date.isNotEmpty)
                      Chip(
                        avatar: const Icon(Icons.calendar_today, size: 14),
                        label: Text(date),
                        backgroundColor: const Color(0xFF2A2A35),
                        labelStyle: const TextStyle(fontSize: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    if (copyright != null && copyright.isNotEmpty)
                      Chip(
                        avatar: const Icon(Icons.copyright, size: 14),
                        label: Text(copyright),
                        backgroundColor: const Color(0xFF2A2A35),
                        labelStyle: const TextStyle(fontSize: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    if (hdUrl != null && hdUrl.isNotEmpty && !isVideo)
                      ActionChip(
                        avatar: const Icon(Icons.high_quality, size: 16, color: Colors.lightBlueAccent),
                        label: const Text("HD Image Available"),
                        backgroundColor: const Color(0xFF2A2A35),
                        labelStyle: const TextStyle(fontSize: 12, color: Colors.lightBlueAccent),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: hdUrl));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("HD image URL copied to clipboard!"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(color: Color(0xFF2A2A35)),
                const SizedBox(height: 8),

                const Text(
                  "Explanation",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  explanation,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ApodOfflineView extends StatelessWidget {
  final VoidCallback onShowCached;
  final VoidCallback? onRetry;
  final ApodException? exception;
  final Map<String, dynamic>? cachedData;

  const ApodOfflineView({
    super.key,
    required this.onShowCached,
    this.onRetry,
    this.exception,
    this.cachedData,
  });

  @override
  Widget build(BuildContext context) {
    final type = exception?.type ?? ApodErrorType.noInternet;

    IconData icon;
    Color iconColor;
    String title;

    switch (type) {
      case ApodErrorType.noInternet:
        icon = Icons.wifi_off_rounded;
        iconColor = Colors.orangeAccent;
        title = "No Internet Connection";
        break;
      case ApodErrorType.rateLimit:
        icon = Icons.speed_rounded;
        iconColor = Colors.amberAccent;
        title = "NASA Rate Limit Reached";
        break;
      case ApodErrorType.invalidApiKey:
        icon = Icons.key_off_rounded;
        iconColor = Colors.redAccent;
        title = "Invalid NASA API Key";
        break;
      case ApodErrorType.serverError:
        icon = Icons.cloud_off_rounded;
        iconColor = Colors.orangeAccent;
        title = "NASA Servers Unavailable";
        break;
      case ApodErrorType.timeout:
        icon = Icons.timer_outlined;
        iconColor = Colors.orangeAccent;
        title = "Connection Timed Out";
        break;
      case ApodErrorType.generic:
        icon = Icons.satellite_alt_rounded;
        iconColor = Colors.orangeAccent;
        title = "Connection Issue";
        break;
    }

    final cachedDate = cachedData?['date']?.toString();
    final cachedTitle = cachedData?['title']?.toString();
    final message = exception?.userFriendlyMessage ??
        "Could not establish connection with NASA servers.";

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 72,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[300],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            // Card showing info about the available cache
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF22222E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.save_as_outlined, color: Colors.amberAccent, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Saved Offline Copy Available",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          cachedTitle ?? (cachedDate != null ? "Picture from $cachedDate" : "Last downloaded picture"),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.history),
                label: Text(
                  cachedDate != null
                      ? "View Saved Picture ($cachedDate)"
                      : "View Saved Picture",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F3D56),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onShowCached,
              ),
            ),

            if (onRetry != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text("Try Connecting Again"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[300],
                    side: BorderSide(color: Colors.grey.withValues(alpha: 0.4)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onRetry,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ApodErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  final Object? error;

  const ApodErrorView({
    super.key,
    required this.onRetry,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final apodException = error is ApodException ? error as ApodException : null;
    final type = apodException?.type ?? ApodErrorType.generic;

    IconData icon;
    Color iconColor;
    String title;

    switch (type) {
      case ApodErrorType.noInternet:
        icon = Icons.wifi_off_rounded;
        iconColor = Colors.redAccent;
        title = "No Internet Connection";
        break;
      case ApodErrorType.rateLimit:
        icon = Icons.speed_rounded;
        iconColor = Colors.amberAccent;
        title = "NASA Rate Limit Reached";
        break;
      case ApodErrorType.invalidApiKey:
        icon = Icons.key_off_rounded;
        iconColor = Colors.redAccent;
        title = "Invalid NASA API Key";
        break;
      case ApodErrorType.serverError:
        icon = Icons.cloud_off_rounded;
        iconColor = Colors.redAccent;
        title = "NASA Server Error";
        break;
      case ApodErrorType.timeout:
        icon = Icons.timer_off_outlined;
        iconColor = Colors.orangeAccent;
        title = "Connection Timed Out";
        break;
      case ApodErrorType.generic:
        icon = Icons.satellite_alt_rounded;
        iconColor = Colors.redAccent;
        title = "Lost Connection in Deep Space!";
        break;
    }

    final message = apodException?.userFriendlyMessage ??
        "An unexpected error occurred while communicating with NASA.";

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 72,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[300],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "No previously downloaded picture was found in local storage.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text("Try Again"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F3D56),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onRetry,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
