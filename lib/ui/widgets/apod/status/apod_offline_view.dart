import 'package:flutter/material.dart';
import 'package:space_app/providers/daily_picture_provider.dart';
import 'package:space_app/utils/app_colors.dart';
import 'apod_error_presentation.dart';
import 'apod_status_layout.dart';

class ApodOfflineView extends StatelessWidget {
  final VoidCallback onShowCached;
  final VoidCallback? onRetry;
  final ApodException? exception;
  final Map<String, dynamic>? cachedData;

  const ApodOfflineView({
    super.key,
    required this.onShowCached,
    this.onRetry,
    this.exception,
    this.cachedData,
  });

  @override
  Widget build(BuildContext context) {
    final type = exception?.type ?? ApodErrorType.noInternet;
    final presentation = ApodErrorPresentation.resolve(type, isWarning: true);

    final cachedDate = cachedData?['date']?.toString();
    final cachedTitle = cachedData?['title']?.toString();
    final message = exception?.userFriendlyMessage ??
        "Could not establish connection with NASA servers.";

    return ApodStatusLayout(
      icon: presentation.icon,
      color: presentation.color,
      title: presentation.title,
      message: message,
      content: _buildCacheCard(cachedTitle, cachedDate),
      primaryAction: ElevatedButton.icon(
        icon: const Icon(Icons.history),
        label: Text(
          cachedDate != null
              ? "View Saved Picture ($cachedDate)"
              : "View Saved Picture",
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.actionButton,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onShowCached,
      ),
      secondaryAction: onRetry != null
          ? OutlinedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text("Try Connecting Again"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[300],
                side: BorderSide(color: Colors.grey.withValues(alpha: 0.4)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onRetry,
            )
          : null,
    );
  }

  Widget _buildCacheCard(String? title, String? date) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.save_as_outlined,
              color: Colors.amberAccent, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Saved Offline Copy Available",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
                Text(
                  title ??
                      (date != null
                          ? "Picture from $date"
                          : "Last downloaded picture"),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
