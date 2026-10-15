import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';

class ImageDownloadService {
  final Dio _dio;

  ImageDownloadService([Dio? dio]) : _dio = dio ?? Dio();

  /// Downloads an image from [imageUrl] and saves it to the device photo gallery.
  /// Falls back to saving to downloads/documents folder on desktop or if gallery access fails.
  /// Returns a user-friendly status message.
  Future<String> downloadAndSaveImage({
    required String imageUrl,
    String? date,
    String? title,
  }) async {
    final cleanUrl = imageUrl.trim();
    if (cleanUrl.isEmpty) {
      throw Exception('Image URL is empty.');
    }

    final response = await _dio.get<List<int>>(
      cleanUrl,
      options: Options(
        responseType: ResponseType.bytes,
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 15),
      ),
    );

    if (response.data == null || response.data!.isEmpty) {
      throw Exception('Received empty image data from server.');
    }

    final bytes = Uint8List.fromList(response.data!);
    final dateSuffix = (date != null && date.trim().isNotEmpty)
        ? date.trim().replaceAll('-', '')
        : DateTime.now().millisecondsSinceEpoch.toString();
    final fileName = 'apod_$dateSuffix';

    // 1. Try saving directly to Gallery via Gal (handles Android MediaStore & iOS Photos)
    try {
      await Gal.putImageBytes(bytes, name: fileName);
      return 'Photo saved to your Gallery!';
    } catch (e) {
      debugPrint('Gal gallery save failed ($e). Falling back to file storage.');
    }

    // 2. Fallback to Downloads / Documents directory (desktop / emulator fallback)
    Directory? targetDir;
    try {
      targetDir = await getDownloadsDirectory();
    } catch (_) {}

    targetDir ??= await getApplicationDocumentsDirectory();

    final filePath = '${targetDir.path}${Platform.pathSeparator}$fileName.jpg';
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    return 'Photo saved to Downloads!';
  }
}
