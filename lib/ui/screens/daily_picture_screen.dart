import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/providers/daily_picture_provider.dart';
import 'package:space_app/ui/widgets/apod_view.dart';

class DailyPictureScreen extends ConsumerStatefulWidget {
  const DailyPictureScreen({super.key});

  @override
  ConsumerState<DailyPictureScreen> createState() => _DailyPictureScreenState();
}

class _DailyPictureScreenState extends ConsumerState<DailyPictureScreen> {
  bool _showCached = false;
  Map<String, dynamic>? _cachedData;

  @override
  Widget build(BuildContext context) {
    final apodData = ref.watch(apodProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Astronomy Picture of the Day"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              setState(() => _showCached = false);
              ScaffoldMessenger.of(context).clearSnackBars();
              ref.invalidate(apodProvider);
              try {
                await ref.read(apodProvider.future);
              } catch (e) {
                // error handled by Riverpod state
              }
            },
          ),
        ],
      ),
      body: _showCached && _cachedData != null
          ? ApodContentView(data: _cachedData!)
          : apodData.when(
              skipLoadingOnRefresh: false,
              data: (data) => ApodContentView(data: data),
              loading: () => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Connecting to NASA server..."),
                  ],
                ),
              ),
              error: (error, stack) {
                if (error is OfflineWithCacheException) {
                  return ApodOfflineView(
                    onShowCached: () {
                      setState(() {
                        _cachedData = error.cachedData;
                        _showCached = true;
                      });
                    },
                  );
                }
                return ApodErrorView(
                  onRetry: () {
                    setState(() => _showCached = false);
                    ref.invalidate(apodProvider);
                  },
                );
              },
            ),
    );
  }
}
