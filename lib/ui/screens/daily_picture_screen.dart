import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/providers/daily_picture_provider.dart';
import 'package:space_app/ui/widgets/apod/apod_view.dart';

class DailyPictureScreen extends ConsumerStatefulWidget {
  const DailyPictureScreen({super.key});

  @override
  ConsumerState<DailyPictureScreen> createState() => _DailyPictureScreenState();
}

class _DailyPictureScreenState extends ConsumerState<DailyPictureScreen> {
  bool _showCached = false;
  Map<String, dynamic>? _cachedData;
  String? _cacheReason;

  Future<void> _refresh() async {
    setState(() {
      _showCached = false;
      _cachedData = null;
      _cacheReason = null;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
    }

    ref.invalidate(apodProvider);

    try {
      await ref.read(apodProvider.future);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text("Picture of the Day updated successfully!"),
              ],
            ),
            backgroundColor: Color(0xFF2E7D32),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final message = e is ApodException
            ? e.userFriendlyMessage
            : 'Could not refresh Picture of the Day.';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(message)),
              ],
            ),
            backgroundColor: const Color(0xFFC62828),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final apodData = ref.watch(apodProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Astronomy Picture of the Day"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Refresh",
            onPressed: _refresh,
          ),
        ],
      ),
      body: _showCached && _cachedData != null
          ? ApodContentView(
              data: _cachedData!,
              isCached: true,
              cacheReason: _cacheReason,
              onRetryOnline: _refresh,
            )
          : apodData.when(
              skipLoadingOnRefresh: false,
              data: (data) => ApodContentView(data: data),
              loading: () => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(strokeWidth: 3),
                      const SizedBox(height: 20),
                      const Text(
                        "Connecting to NASA server...",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Downloading Astronomy Picture of the Day",
                        style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
              ),
              error: (error, stack) {
                if (error is ApodException && error.hasCache) {
                  return ApodOfflineView(
                    exception: error,
                    cachedData: error.cachedData,
                    onShowCached: () {
                      setState(() {
                        _cachedData = error.cachedData;
                        _cacheReason = error.userFriendlyMessage;
                        _showCached = true;
                      });
                    },
                    onRetry: _refresh,
                  );
                }

                // If error is not ApodException but has cache check
                if (error is OfflineWithCacheException) {
                  return ApodOfflineView(
                    exception: error,
                    cachedData: error.cachedData,
                    onShowCached: () {
                      setState(() {
                        _cachedData = error.cachedData;
                        _cacheReason = error.userFriendlyMessage;
                        _showCached = true;
                      });
                    },
                    onRetry: _refresh,
                  );
                }

                return ApodErrorView(
                  error: error,
                  onRetry: _refresh,
                );
              },
            ),
    );
  }
}
