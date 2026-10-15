import 'package:flutter/material.dart';
import 'package:space_app/providers/daily_picture_provider.dart';
import 'package:space_app/utils/app_colors.dart';
import 'apod_error_presentation.dart';
import 'apod_status_layout.dart';

class ApodErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  final Object? error;

  const ApodErrorView({
    super.key,
    required this.onRetry,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final apodException =
        error is ApodException ? error as ApodException : null;
    final type = apodException?.type ?? ApodErrorType.generic;
    final presentation = ApodErrorPresentation.resolve(type);

    final message = apodException?.userFriendlyMessage ??
        "NASA service is currently unreachable. Please try again later.";

    return ApodStatusLayout(
      icon: presentation.icon,
      color: presentation.color,
      title: presentation.title,
      message: message,
      content: Text(
        "No previously downloaded picture was found in local storage.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[500],
        ),
      ),
      primaryAction: ElevatedButton.icon(
        icon: const Icon(Icons.refresh),
        label: const Text("Try Again"),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.actionButton,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onRetry,
      ),
    );
  }
}
