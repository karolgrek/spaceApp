import 'package:flutter/material.dart';

class ApodContentView extends StatelessWidget {
  final Map<String, dynamic> data;

  const ApodContentView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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
                  title ?? '',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  explanation ?? '',
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

class ApodOfflineView extends StatelessWidget {
  final VoidCallback onShowCached;

  const ApodOfflineView({super.key, required this.onShowCached});

  @override
  Widget build(BuildContext context) {
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
              onPressed: onShowCached,
            ),
          ],
        ),
      ),
    );
  }
}

class ApodErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const ApodErrorView({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
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
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
