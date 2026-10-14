import 'package:flutter/material.dart';

/// Notice banner displayed on top of APOD when viewing a cached or offline copy.
class ApodCachedBanner extends StatelessWidget {
  final String? date;
  final String? reason;
  final VoidCallback? onRetry;

  const ApodCachedBanner({
    super.key,
    this.date,
    this.reason,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.history_toggle_off,
            color: Colors.amberAccent,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Offline Mode \u2022 Showing Saved Picture${(date != null && date!.isNotEmpty) ? ' ($date)' : ''}",
                  style: const TextStyle(
                    color: Colors.amberAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                if (reason != null && reason!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      reason!,
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (onRetry != null)
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.amberAccent,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text("Retry"),
              onPressed: onRetry,
            ),
        ],
      ),
    );
  }
}
