import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/providers/daily_picture_provider.dart';
import 'package:space_app/ui/screens/daily_picture_screen.dart';

class DailyPictureBanner extends ConsumerWidget {
  const DailyPictureBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apodData = ref.watch(apodProvider);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DailyPictureScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        height: 130,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.secondary,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            apodData.when(
              data: (data) {
                final isVideo =
                    data['media_type']?.toString().toLowerCase() == 'video';
                final imageUrl = (isVideo
                            ? data['thumbnail_url']
                            : data['url'])
                        ?.toString() ??
                    data['url']?.toString() ??
                    '';

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    if (imageUrl.isNotEmpty)
                      Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 130,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return _buildLoadingPlaceholder();
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            _buildNasaFallback(),
                      )
                    else
                      _buildNasaFallback(),
                    if (isVideo)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: _buildBadge(
                          icon: Icons.play_arrow_rounded,
                          label: "VIDEO",
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                );
              },
              loading: () => _buildLoadingPlaceholder(),
              error: (err, stack) {
                Map<String, dynamic>? cachedData;
                if (err is ApodException && err.hasCache) {
                  cachedData = err.cachedData;
                } else if (err is OfflineWithCacheException) {
                  cachedData = err.cachedData;
                }

                if (cachedData != null) {
                  final isVideo =
                      cachedData['media_type']?.toString().toLowerCase() ==
                          'video';
                  final url = (isVideo
                              ? cachedData['thumbnail_url']
                              : cachedData['url'])
                          ?.toString() ??
                      cachedData['url']?.toString();

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      if (url != null && url.isNotEmpty)
                        Image.network(
                          url,
                          width: double.infinity,
                          height: 130,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildNasaFallback(),
                        )
                      else
                        _buildNasaFallback(),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: _buildBadge(
                          icon: Icons.history,
                          label: "OFFLINE",
                          color: Colors.amberAccent,
                        ),
                      ),
                    ],
                  );
                }

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildNasaFallback(),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: _buildBadge(
                        icon: Icons.error_outline,
                        label: "TAP FOR INFO",
                        color: Colors.orangeAccent,
                      ),
                    ),
                  ],
                );
              },
            ),

            // Gradient overlay for contrast
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black87,
                      Colors.black54,
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.45, 1.0],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),

            // Banner title & subtitle text
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Astronomy Picture of the Day",
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  apodData.when(
                    data: (data) => Text(
                      data['title']?.toString() ?? 'Explore today\'s NASA photo',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    loading: () => const Text(
                      "Fetching from NASA...",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    error: (err, stack) {
                      Map<String, dynamic>? cachedData;
                      if (err is ApodException && err.hasCache) {
                        cachedData = err.cachedData;
                      } else if (err is OfflineWithCacheException) {
                        cachedData = err.cachedData;
                      }

                      if (cachedData != null) {
                        return Text(
                          cachedData['title']?.toString() ?? 'Offline copy available',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        );
                      }

                      return const Text(
                        "Unable to load \u2022 Tap to view status",
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      height: 130,
      width: double.infinity,
      color: const Color(0xFF1E1E28),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNasaFallback() {
    return Image.asset(
      'assets/images/nasa_logo.png',
      height: 130,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
