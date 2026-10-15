import 'package:flutter_test/flutter_test.dart';
import 'package:space_app/providers/daily_picture_provider.dart';

void main() {
  group('ApodException Unit Tests', () {
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
}
