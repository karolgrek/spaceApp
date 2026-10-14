import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/models/apod_item.dart';
import 'package:space_app/providers/daily_picture_provider.dart';
import 'package:space_app/ui/screens/daily_picture_screen.dart';

class DailyPictureBanner extends ConsumerWidget {
  const DailyPictureBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apodData = ref.watch(apodProvider);
    final info = _resolveBannerInfo(apodData);

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
          fit: StackFit.expand,
          children: [
            _buildBackground(info),
            _buildGradientOverlay(),
            _buildContent(info),
            if (info.badge != null)
              Positioned(
                top: 10,
                right: 10,
                child: _buildBadge(info.badge!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground(_BannerInfo info) {
    if (info.isLoading) {
      return Container(
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

    if (info.imageUrl != null && info.imageUrl!.isNotEmpty) {
      return Image.network(
        info.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
      );
    }

    return _buildFallbackImage();
  }

  Widget _buildFallbackImage() {
    return Image.asset(
      'assets/images/nasa_logo.png',
      fit: BoxFit.cover,
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black87, Colors.black54, Colors.transparent],
          stops: [0.0, 0.45, 1.0],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
    );
  }

  Widget _buildContent(_BannerInfo info) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
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
          Text(
            info.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: info.isError ? Colors.orangeAccent : Colors.white,
              fontWeight: info.isError ? FontWeight.w500 : FontWeight.bold,
              fontSize: info.isError ? 13 : 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(_BannerBadge badge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badge.color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badge.icon, size: 12, color: badge.color),
          const SizedBox(width: 4),
          Text(
            badge.label,
            style: TextStyle(
              color: badge.color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  _BannerInfo _resolveBannerInfo(AsyncValue<Map<String, dynamic>> apodData) {
    return apodData.when(
      data: (data) {
        final item = ApodItem.fromMap(data);
        return _BannerInfo(
          title: item.title,
          imageUrl: item.imageUrl,
          badge: item.isVideo
              ? const _BannerBadge(
                  icon: Icons.play_arrow_rounded,
                  label: "VIDEO",
                  color: Colors.redAccent,
                )
              : null,
        );
      },
      loading: () => const _BannerInfo(
        title: "Fetching from NASA...",
        isLoading: true,
      ),
      error: (err, _) {
        Map<String, dynamic>? cache;
        if (err is ApodException && err.hasCache) {
          cache = err.cachedData;
        } else if (err is OfflineWithCacheException) {
          cache = err.cachedData;
        }

        if (cache != null) {
          final cachedItem = ApodItem.fromMap(cache);
          return _BannerInfo(
            title: cachedItem.title.isNotEmpty
                ? cachedItem.title
                : 'Offline copy available',
            imageUrl: cachedItem.imageUrl,
            badge: const _BannerBadge(
              icon: Icons.history,
              label: "OFFLINE",
              color: Colors.amberAccent,
            ),
          );
        }

        return const _BannerInfo(
          title: "Unable to load \u2022 Tap to view status",
          isError: true,
          badge: _BannerBadge(
            icon: Icons.error_outline,
            label: "TAP FOR INFO",
            color: Colors.orangeAccent,
          ),
        );
      },
    );
  }
}

class _BannerInfo {
  final String title;
  final String? imageUrl;
  final bool isLoading;
  final bool isError;
  final _BannerBadge? badge;

  const _BannerInfo({
    required this.title,
    this.imageUrl,
    this.isLoading = false,
    this.isError = false,
    this.badge,
  });
}

class _BannerBadge {
  final IconData icon;
  final String label;
  final Color color;

  const _BannerBadge({
    required this.icon,
    required this.label,
    required this.color,
  });
}
