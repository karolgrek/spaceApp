import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// NASA's official modern APOD endpoint (science.nasa.gov)
const String apodApiUrl =
    'https://science.nasa.gov/wp-json/wp/v2/apod-basic?per_page=1';

enum ApodErrorType {
  noInternet,
  timeout,
  rateLimit,
  serverError,
  generic,
}

class ApodException implements Exception {
  final String message;
  final String userFriendlyMessage;
  final ApodErrorType type;
  final int? statusCode;
  final Map<String, dynamic>? cachedData;

  ApodException({
    required this.message,
    required this.userFriendlyMessage,
    required this.type,
    this.statusCode,
    this.cachedData,
  });

  bool get hasCache => cachedData != null;

  @override
  String toString() => userFriendlyMessage;
}

class OfflineWithCacheException extends ApodException {
  OfflineWithCacheException(
    Map<String, dynamic> cachedData, {
    String? message,
    String? userFriendlyMessage,
    super.type = ApodErrorType.noInternet,
    super.statusCode,
  }) : super(
          message: message ?? 'Offline with cached data',
          userFriendlyMessage: userFriendlyMessage ??
              'No internet connection. A saved picture is available offline.',
          cachedData: cachedData,
        );
}

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
});

final apodProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final dio = ref.watch(dioProvider);
  final box = Hive.box('apod_cache');

  try {
    final response = await dio.get(apodApiUrl);
    final dynamic rawData = response.data is String
        ? jsonDecode(response.data)
        : response.data;

    final List list = rawData is List ? rawData : [rawData];
    if (list.isEmpty) {
      throw const FormatException('Empty response from NASA');
    }

    final item = Map<String, dynamic>.from(list.first as Map);

    // Clean explanation HTML
    String explanation = (item['explanation']?.toString() ?? '')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&#039;', "'")
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .trim();
    if (explanation.toLowerCase().startsWith('explanation:')) {
      explanation = explanation.substring(12).trim();
    }

    // Clean copyright/credit HTML
    String? copyright = (item['credit'] ?? item['copyright'])?.toString();
    if (copyright != null) {
      copyright = copyright
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .replaceAll('\n', ' ')
          .trim();
    }

    final mediaType = item['media_type']?.toString().toLowerCase() ?? 'image';
    final isVideo = mediaType == 'video';
    final rawUrl = item['url']?.toString();
    final thumbnailUrl = item['thumbnail_url']?.toString();
    final hdUrl = item['hdurl']?.toString();
    final imageUrl = (isVideo
            ? (thumbnailUrl ?? rawUrl)
            : (hdUrl != null && hdUrl.isNotEmpty ? hdUrl : rawUrl)) ??
        '';

    final result = {
      'title': item['title']?.toString() ?? 'Astronomy Picture of the Day',
      'explanation': explanation,
      'date': item['date']?.toString(),
      'copyright': copyright,
      'media_type': mediaType,
      'url': imageUrl,
      'thumbnail_url': thumbnailUrl,
      'video_url': isVideo ? rawUrl : null,
      'hdurl': hdUrl ?? imageUrl,
    };

    await box.put('latest_apod', result);
    return result;
  } catch (e) {
    final rawCache = box.get('latest_apod');
    if (rawCache is Map) {
      final cachedMap = Map<String, dynamic>.from(rawCache);
      // Don't serve old broken NASA logo from cache
      if (!cachedMap['url'].toString().contains('nasa-logo')) {
        throw OfflineWithCacheException(cachedMap);
      }
    }

    throw ApodException(
      message: e.toString(),
      userFriendlyMessage:
          'Could not load Picture of the Day. Please check your internet connection.',
      type: ApodErrorType.noInternet,
    );
  }
});
