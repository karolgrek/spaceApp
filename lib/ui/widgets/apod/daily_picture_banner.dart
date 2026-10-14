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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DailyPictureScreen()),
        );
      },
      child: Container(
        width: double.infinity,
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
              data: (data) => Image.network(
                data['url'] ?? '',
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildNasaFallback(),
              ),
              loading: () => Container(
                height: 120,
                color: Colors.deepPurpleAccent.withValues(alpha: 0.4),
                child: const Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) {
                if (err is OfflineWithCacheException) {
                  final url = err.cachedData['url'];
                  if (url != null && url is String && url.isNotEmpty) {
                    return Image.network(
                      url,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildNasaFallback(),
                    );
                  }
                }
                return _buildNasaFallback();
              },
            ),
            Container(
              height: 120,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black87, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Astronomy Picture of the Day",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNasaFallback() {
    return Image.asset(
      'assets/images/nasa_logo.png',
      height: 120,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
