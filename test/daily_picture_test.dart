import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_app/providers/daily_picture_provider.dart';
import 'package:space_app/ui/screens/daily_picture_screen.dart';
import 'package:space_app/ui/widgets/apod/content/apod_content_view.dart';
import 'package:space_app/ui/widgets/apod/daily_picture_banner.dart';
import 'package:space_app/ui/widgets/apod/status/apod_error_view.dart';
import 'package:space_app/ui/widgets/apod/status/apod_offline_view.dart';

void main() {
  group('ApodException tests', () {
    test('ApodException holds correct type, message and cache', () {
      final cache = {'title': 'Cached Mars', 'date': '2026-10-10'};
      final ex = ApodException(
        message: 'DioException 429',
        userFriendlyMessage: 'Rate limit reached',
        type: ApodErrorType.rateLimit,
        statusCode: 429,
        cachedData: cache,
      );

      expect(ex.type, ApodErrorType.rateLimit);
      expect(ex.statusCode, 429);
      expect(ex.hasCache, isTrue);
      expect(ex.cachedData?['title'], 'Cached Mars');
      expect(ex.toString(), 'Rate limit reached');
    });

    test('OfflineWithCacheException extends ApodException', () {
      final cache = {'title': 'Cached Galaxy', 'date': '2026-10-09'};
      final ex = OfflineWithCacheException(cache);

      expect(ex, isA<ApodException>());
      expect(ex.type, ApodErrorType.noInternet);
      expect(ex.hasCache, isTrue);
      expect(ex.cachedData?['title'], 'Cached Galaxy');
    });
  });

  group('ApodContentView Widget tests', () {
    testWidgets('renders photo APOD details correctly', (tester) async {
      final sampleData = {
        'title': 'The Pillars of Creation',
        'date': '2026-10-14',
        'explanation': 'A stunning view of star forming gas in the Eagle Nebula.',
        'copyright': 'NASA, ESA, CSA, STScI',
        'media_type': 'image',
        'url': 'https://example.com/pillars.jpg',
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ApodContentView(data: sampleData),
          ),
        ),
      );

      expect(find.text('The Pillars of Creation'), findsOneWidget);
      expect(find.text('2026-10-14'), findsOneWidget);
      expect(find.text('NASA, ESA, CSA, STScI'), findsOneWidget);
      expect(
        find.text('A stunning view of star forming gas in the Eagle Nebula.'),
        findsOneWidget,
      );
      expect(find.text('PHOTO'), findsOneWidget);
    });

    testWidgets('renders video APOD badge and media overlay', (tester) async {
      final sampleData = {
        'title': 'Simulation of Black Hole Merger',
        'date': '2026-10-13',
        'explanation': 'Supercomputer simulation of two colliding black holes.',
        'media_type': 'video',
        'url': 'https://www.youtube.com/watch?v=12345',
        'thumbnail_url': 'https://example.com/thumb.jpg',
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ApodContentView(data: sampleData),
          ),
        ),
      );

      expect(find.text('Simulation of Black Hole Merger'), findsOneWidget);
      expect(find.text('VIDEO'), findsOneWidget);
    });

    testWidgets('renders cached banner when isCached is true', (tester) async {
      final sampleData = {
        'title': 'Yesterday Moon',
        'date': '2026-10-13',
        'explanation': 'Full moon explanation.',
        'media_type': 'image',
        'url': 'https://example.com/moon.jpg',
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ApodContentView(
              data: sampleData,
              isCached: true,
              cacheReason: 'Offline mode',
            ),
          ),
        ),
      );

      expect(
        find.text('Offline Mode \u2022 Showing Saved Picture (2026-10-13)'),
        findsOneWidget,
      );
      expect(find.text('Offline mode'), findsOneWidget);
    });
  });

  group('ApodOfflineView tests', () {
    testWidgets('renders noInternet error with cache info and triggers callback',
        (tester) async {
      bool shownCache = false;
      final cached = {'title': 'Cached Saturn', 'date': '2026-10-12'};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ApodOfflineView(
              cachedData: cached,
              exception: ApodException(
                message: 'No connection',
                userFriendlyMessage: 'No internet connection detected.',
                type: ApodErrorType.noInternet,
                cachedData: cached,
              ),
              onShowCached: () {
                shownCache = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('No Internet Connection'), findsOneWidget);
      expect(find.text('No internet connection detected.'), findsOneWidget);
      expect(find.text('View Saved Picture (2026-10-12)'), findsOneWidget);

      await tester.tap(find.text('View Saved Picture (2026-10-12)'));
      await tester.pump();
      expect(shownCache, isTrue);
    });

    testWidgets('renders rateLimit error with cache info', (tester) async {
      final cached = {'title': 'Cached Jupiter', 'date': '2026-10-11'};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ApodOfflineView(
              cachedData: cached,
              exception: ApodException(
                message: 'Rate limit 429',
                userFriendlyMessage: 'NASA API rate limit exceeded.',
                type: ApodErrorType.rateLimit,
                statusCode: 429,
                cachedData: cached,
              ),
              onShowCached: () {},
            ),
          ),
        ),
      );

      expect(find.text('NASA Rate Limit Reached'), findsOneWidget);
      expect(find.text('NASA API rate limit exceeded.'), findsOneWidget);
      expect(find.byIcon(Icons.speed_rounded), findsOneWidget);
    });
  });

  group('ApodErrorView tests', () {
    testWidgets('renders specific error view without cache', (tester) async {
      bool retried = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ApodErrorView(
              error: ApodException(
                message: 'Server error 500',
                userFriendlyMessage: 'NASA service is currently unreachable.',
                type: ApodErrorType.serverError,
                statusCode: 500,
              ),
              onRetry: () {
                retried = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('NASA Service Unavailable'), findsOneWidget);
      expect(find.text('NASA service is currently unreachable.'), findsOneWidget);
      expect(
        find.text('No previously downloaded picture was found in local storage.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Try Again'));
      await tester.pump();
      expect(retried, isTrue);
    });
  });

  group('DailyPictureBanner tests', () {
    testWidgets('displays title and image in data state', (tester) async {
      final container = ProviderContainer(
        overrides: [
          apodProvider.overrideWith((ref) async => {
                'title': 'Aurora Over Norway',
                'url': 'https://example.com/aurora.jpg',
                'media_type': 'image',
              }),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: DailyPictureBanner(),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Astronomy Picture of the Day'), findsOneWidget);
      expect(find.text('Aurora Over Norway'), findsOneWidget);
    });

    testWidgets('displays offline badge in banner when cached', (tester) async {
      final container = ProviderContainer(
        overrides: [
          apodProvider.overrideWith((ref) async {
            throw OfflineWithCacheException(
              {
                'title': 'Offline Crab Nebula',
                'url': 'https://example.com/crab.jpg',
                'date': '2026-10-10',
              },
            );
          }),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: DailyPictureBanner(),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('OFFLINE'), findsOneWidget);
      expect(find.text('Offline Crab Nebula'), findsOneWidget);
    });
  });

  group('DailyPictureScreen screen transition tests', () {
    testWidgets('switches to cached picture when user clicks View Saved Picture',
        (tester) async {
      final cached = {
        'title': 'Saved Andromeda Galaxy',
        'date': '2026-10-12',
        'explanation': 'Our neighboring spiral galaxy.',
        'media_type': 'image',
        'url': 'https://example.com/andromeda.jpg',
      };

      final container = ProviderContainer(
        overrides: [
          apodProvider.overrideWith((ref) async {
            throw OfflineWithCacheException(
              cached,
              userFriendlyMessage: 'No internet connection detected.',
            );
          }),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: DailyPictureScreen(),
          ),
        ),
      );

      await tester.pump();

      // Initially shows ApodOfflineView
      expect(find.text('No Internet Connection'), findsOneWidget);
      expect(find.text('View Saved Picture (2026-10-12)'), findsOneWidget);

      // Tap View Saved Picture
      await tester.tap(find.text('View Saved Picture (2026-10-12)'));
      await tester.pumpAndSettle();

      // Now should show ApodContentView with cached Andromeda
      expect(find.text('Saved Andromeda Galaxy'), findsOneWidget);
      expect(
        find.text('Offline Mode \u2022 Showing Saved Picture (2026-10-12)'),
        findsOneWidget,
      );
      expect(find.text('No internet connection detected.'), findsOneWidget);
    });
  });
}
