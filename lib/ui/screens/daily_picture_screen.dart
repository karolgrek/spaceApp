import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/providers/daily_picture_provider.dart';

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
              try {
                await ref.refresh(apodProvider.future);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'The latest astronomy picture is currently loaded!',
                      ),
                      backgroundColor: Colors.blueAccent,
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              } catch (e) {
                // no need to do anything since the error will be displayed automatically by Riverpod
              }
            },
          ),
        ],
      ),
      body: _showCached && _cachedData != null
          ? _buildPictureContent(_cachedData!)
          : apodData.when(
              skipLoadingOnRefresh: false,
              data: (data) => _buildPictureContent(data),
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
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.signal_wifi_off,
                            size: 80,
                            color: Colors.orangeAccent,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "No Internet Connection",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Would you like to see the last downloaded Picture of the Day instead?",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.history),
                            label: const Text("Yes, better than nothing!"),
                            onPressed: () {
                              setState(() {
                                _cachedData = error.cachedData;
                                _showCached = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.wifi_off,
                          size: 80,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Lost connection in deep space!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text("Try Again"),
                          onPressed: () {
                            setState(() => _showCached = false);
                            ref.invalidate(apodProvider);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildPictureContent(Map<String, dynamic> data) {
    final imageUrl = data['url'];
    final title = data['title'];
    final explanation = data['explanation'];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            height: 350,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 350,
              color: Colors.grey[800],
              child: const Center(
                child: Icon(Icons.satellite_alt, size: 80, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  explanation,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
