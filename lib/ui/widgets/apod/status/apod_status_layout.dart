import 'package:flutter/material.dart';

/// Reusable status layout for APOD error and offline screens.
class ApodStatusLayout extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String message;
  final Widget? content;
  final Widget primaryAction;
  final Widget? secondaryAction;

  const ApodStatusLayout({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
    this.content,
    required this.primaryAction,
    this.secondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 72, color: color),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[300],
                height: 1.4,
              ),
            ),
            if (content != null) ...[
              const SizedBox(height: 20),
              content!,
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: primaryAction,
            ),
            if (secondaryAction != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: secondaryAction!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
