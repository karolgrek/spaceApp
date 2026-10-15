import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/providers/daily_picture_provider.dart';
import 'package:space_app/ui/widgets/apod/content/apod_content_view.dart';
import 'package:space_app/ui/widgets/apod/status/apod_error_view.dart';
import 'package:space_app/ui/widgets/apod/status/apod_offline_view.dart';
import 'package:space_app/ui/widgets/feedback/app_snackbar.dart';
import 'package:space_app/utils/app_strings.dart';

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

    ref.invalidate(apodProvider);

    try {
      await ref.read(apodProvider.future);
      if (mounted) {
        AppSnackBar.showSuccess(
          context,
          AppStrings.apodUpdatedSuccess,
        );
      }
    } catch (e) {
      if (mounted) {
        if (e is ApodException && e.hasCache) {
          AppSnackBar.showWarning(
            context,
            AppStrings.couldNotConnectToNasaNotice,
            icon: Icons.cloud_off_rounded,
          );
        } else {
          final message = e is ApodException
              ? e.userFriendlyMessage
              : AppStrings.couldNotRefreshApod;
          AppSnackBar.showError(
            context,
            message,
            icon: Icons.cloud_off_rounded,
          );
        }
      }
    }
  }

  void _switchToCached(Map<String, dynamic>? data, String? reason) {
    setState(() {
      _cachedData = data;
      _cacheReason = reason;
      _showCached = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final apodData = ref.watch(apodProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.apodTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: AppStrings.retry,
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
              loading: () => const _LoadingView(),
              error: (error, _) {
                if (error is ApodException && error.hasCache) {
                  return ApodOfflineView(
                    exception: error,
                    cachedData: error.cachedData,
                    onShowCached: () =>
                        _switchToCached(error.cachedData, error.userFriendlyMessage),
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

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(strokeWidth: 3),
            const SizedBox(height: 20),
            const Text(
              AppStrings.connectingToNasa,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              AppStrings.downloadingApod,
              style: TextStyle(fontSize: 13, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }
}
