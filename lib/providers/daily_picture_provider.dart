import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String nasaApiUrl = 'https://api.nasa.gov/planetary/apod';
String get nasaApiKey => dotenv.env['NASA_API_KEY'] ?? 'DEMO_KEY';

enum ApodErrorType {
  noInternet,
  timeout,
  rateLimit,
  invalidApiKey,
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
              'No internet connection. Showing cached picture.',
          cachedData: cachedData,
        );
}

String _formatDate(DateTime dt) {
  final y = dt.year.toString().padLeft(4, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

final apodProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
    ),
  );
  final box = Hive.box('apod_cache');

  try {
    // NASA's APOD backend has a known bug where omitting the 'date' parameter
    // causes a 500 Internal Service Error whenever their server timezone or daily
    // indexing is out of sync. Passing an explicit date fixes this.
    // If today is not yet published (e.g., timezone difference between Europe and US),
    // we automatically fall back to yesterday's date.
    final now = DateTime.now();
    final todayDate = _formatDate(now);
    final yesterdayDate = _formatDate(now.subtract(const Duration(days: 1)));

    Response<dynamic>? response;
    DioException? lastDioException;

    // 1. Try today's date first
    try {
      response = await dio.get(
        '$nasaApiUrl?api_key=$nasaApiKey&date=$todayDate&thumbs=true',
      );
    } on DioException catch (dioErr) {
      lastDioException = dioErr;
      final code = dioErr.response?.statusCode;
      // If NASA responds with 500 or 404 (today's entry not yet indexed/published),
      // attempt yesterday's entry as a graceful fallback.
      if (code == 500 || code == 404) {
        try {
          response = await dio.get(
            '$nasaApiUrl?api_key=$nasaApiKey&date=$yesterdayDate&thumbs=true',
          );
        } on DioException catch (fallbackErr) {
          lastDioException = fallbackErr;
        }
      }
    }

    if (response != null && response.data is Map) {
      final dataMap = Map<String, dynamic>.from(response.data as Map);
      await box.put('latest_apod', dataMap);
      return dataMap;
    }

    if (lastDioException != null) {
      throw lastDioException;
    }

    throw const FormatException('Unexpected response format from NASA API');
  } catch (e) {
    // Check if cached data exists in Hive
    final rawCache = box.get('latest_apod');
    final Map<String, dynamic>? cachedData = rawCache is Map
        ? Map<String, dynamic>.from(rawCache)
        : null;

    ApodErrorType errorType = ApodErrorType.generic;
    int? statusCode;
    String userMessage = 'Unable to load Picture of the Day. Please try again.';

    if (e is DioException) {
      statusCode = e.response?.statusCode;

      // Extract custom NASA error message if present in response
      String? nasaErrorMessage;
      if (e.response?.data is Map) {
        final errorObj = e.response!.data['error'];
        if (errorObj is Map && errorObj['message'] != null) {
          nasaErrorMessage = errorObj['message'].toString();
        } else if (e.response!.data['msg'] != null) {
          nasaErrorMessage = e.response!.data['msg'].toString();
        }
      }

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorType = ApodErrorType.timeout;
          userMessage =
              'Connection to NASA servers timed out. The server might be busy or your internet connection is slow.';
          break;

        case DioExceptionType.connectionError:
          errorType = ApodErrorType.noInternet;
          userMessage =
              'No internet connection detected. Please check your network connection.';
          break;

        case DioExceptionType.badResponse:
          if (statusCode == 429) {
            errorType = ApodErrorType.rateLimit;
            userMessage = nasaErrorMessage ??
                'NASA API rate limit exceeded. If using DEMO_KEY, limits are 30 requests/hour and 50/day. Try again later or add your personal API key.';
          } else if (statusCode == 403) {
            errorType = ApodErrorType.invalidApiKey;
            userMessage = nasaErrorMessage ??
                'Invalid NASA API key. Please check your NASA_API_KEY in the .env file.';
          } else if (statusCode != null && statusCode >= 500) {
            errorType = ApodErrorType.serverError;
            userMessage =
                'NASA servers are experiencing issues (HTTP $statusCode). Please try again shortly.';
          } else {
            errorType = ApodErrorType.generic;
            userMessage = nasaErrorMessage ??
                'NASA server returned an error (HTTP $statusCode).';
          }
          break;

        default:
          if (e.error is SocketException) {
            errorType = ApodErrorType.noInternet;
            userMessage =
                'No internet connection detected. Please check your network connection.';
          } else {
            errorType = ApodErrorType.generic;
            userMessage =
                'A connection error occurred while contacting NASA.';
          }
          break;
      }
    } else if (e is SocketException) {
      errorType = ApodErrorType.noInternet;
      userMessage =
          'No internet connection detected. Please check your network connection.';
    }

    if (cachedData != null) {
      throw OfflineWithCacheException(
        cachedData,
        message: e.toString(),
        userFriendlyMessage: userMessage,
        type: errorType,
        statusCode: statusCode,
      );
    }

    throw ApodException(
      message: e.toString(),
      userFriendlyMessage: userMessage,
      type: errorType,
      statusCode: statusCode,
      cachedData: null,
    );
  }
});
