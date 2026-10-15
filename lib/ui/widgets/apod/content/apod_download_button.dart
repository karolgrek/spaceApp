import 'dart:async';
import 'package:flutter/material.dart';
import 'package:space_app/services/image_download_service.dart';
import 'package:space_app/ui/widgets/feedback/app_snackbar.dart';
import 'package:space_app/utils/app_colors.dart';

class ApodDownloadButton extends StatefulWidget {
  final String imageUrl;
  final String? date;
  final String? title;
  final ImageDownloadService? downloadService;

  const ApodDownloadButton({
    super.key,
    required this.imageUrl,
    this.date,
    this.title,
    this.downloadService,
  });

  @override
  State<ApodDownloadButton> createState() => _ApodDownloadButtonState();
}

class _ApodDownloadButtonState extends State<ApodDownloadButton> {
  bool _isDownloading = false;
  bool _isDownloaded = false;
  Timer? _resetTimer;

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  Future<void> _handleDownload() async {
    if (_isDownloading || widget.imageUrl.trim().isEmpty) return;

    setState(() {
      _isDownloading = true;
    });

    try {
      final service = widget.downloadService ?? ImageDownloadService();
      final message = await service.downloadAndSaveImage(
        imageUrl: widget.imageUrl,
        date: widget.date,
        title: widget.title,
      );

      if (!mounted) return;
      setState(() {
        _isDownloading = false;
        _isDownloaded = true;
      });

      AppSnackBar.showSuccess(context, message);

      // Revert the "Saved" status indicator back to "Download" after 3 seconds
      _resetTimer?.cancel();
      _resetTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isDownloaded = false;
          });
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isDownloading = false;
      });
      AppSnackBar.showError(
        context,
        'Failed to download: ${e.toString().replaceAll('Exception: ', '')}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final (icon, label, color) = switch ((_isDownloading, _isDownloaded)) {
      (true, _) => (null, 'Downloading...', Colors.cyanAccent),
      (false, true) => (
          Icons.check_circle_outline,
          'Saved',
          Colors.greenAccent
        ),
      (false, false) => (
          Icons.file_download_outlined,
          'Download',
          Colors.cyanAccent
        ),
    };

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _isDownloading ? null : _handleDownload,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.cardSecondary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isDownloading)
                const SizedBox(
                  width: 13,
                  height: 13,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                  ),
                )
              else
                Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
