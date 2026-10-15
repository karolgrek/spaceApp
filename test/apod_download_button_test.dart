import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_app/services/image_download_service.dart';
import 'package:space_app/ui/widgets/apod/content/apod_content_view.dart';
import 'package:space_app/ui/widgets/apod/content/apod_download_button.dart';

class _FakeDownloadService extends ImageDownloadService {
  final String result;
  _FakeDownloadService({required this.result});

  @override
  Future<String> downloadAndSaveImage({
    required String imageUrl,
    String? date,
    String? title,
  }) async {
    await Future.delayed(const Duration(milliseconds: 10));
    return result;
  }
}

void main() {
  group('ApodDownloadButton & Metadata Section tests', () {
    testWidgets('renders download button next to date when image is present',
        (tester) async {
      final sampleData = {
        'title': 'Orion Nebula',
        'date': '2026-10-15',
        'explanation': 'Nebula details...',
        'media_type': 'image',
        'url': 'https://example.com/orion.jpg',
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ApodContentView(data: sampleData),
          ),
        ),
      );

      expect(find.text('2026-10-15'), findsOneWidget);
      expect(find.text('Download'), findsOneWidget);
      expect(find.byIcon(Icons.file_download_outlined), findsOneWidget);
    });

    testWidgets('does not render download button for video media',
        (tester) async {
      final sampleVideo = {
        'title': 'Mars Flyby',
        'date': '2026-10-14',
        'explanation': 'Video flyby of Olympus Mons',
        'media_type': 'video',
        'url': 'https://youtube.com/watch?v=12345',
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ApodContentView(data: sampleVideo),
          ),
        ),
      );

      expect(find.text('2026-10-14'), findsOneWidget);
      expect(find.text('Download'), findsNothing);
    });

    testWidgets(
        'tapping download button triggers download and shows saved state',
        (tester) async {
      final fakeService = _FakeDownloadService(
        result: 'Photo saved to your Gallery!',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ApodDownloadButton(
              imageUrl: 'https://example.com/photo.jpg',
              date: '2026-10-15',
              title: 'Star Cluster',
              downloadService: fakeService,
            ),
          ),
        ),
      );

      expect(find.text('Download'), findsOneWidget);

      await tester.tap(find.text('Download'));
      await tester.pump();

      // State is downloading
      expect(find.text('Downloading...'), findsOneWidget);

      await tester.pumpAndSettle();

      // State is saved with success snackbar
      expect(find.text('Saved'), findsOneWidget);
      expect(find.text('Photo saved to your Gallery!'), findsOneWidget);

      // Fast-forward the 3-second reset timer
      await tester.pump(const Duration(seconds: 4));
      expect(find.text('Download'), findsOneWidget);
    });
  });
}
