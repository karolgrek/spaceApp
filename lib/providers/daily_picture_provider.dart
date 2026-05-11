import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String nasaApiUrl = 'https://api.nasa.gov/planetary/apod';
final String nasaApiKey = dotenv.env['NASA_API_KEY'] ?? 'DEMO_KEY';

class OfflineWithCacheException implements Exception {
  final Map<String, dynamic> cachedData;
  OfflineWithCacheException(this.cachedData);
}

final apodProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final dio = Dio();
  final box = Hive.box('apod_cache');

  try {
    final response = await dio.get('$nasaApiUrl?api_key=$nasaApiKey');
    box.put('latest_apod', response.data);
    return response.data;
  } catch (e) {
    final cachedData = box.get('latest_apod');
    if (cachedData != null) {
      throw OfflineWithCacheException(Map<String, dynamic>.from(cachedData));
    }
    throw Exception('Houston, we have a problem: $e');
  }
});
