import 'dart:ui';
import 'package:flutter/material.dart';

class AppSnackBar {
  static void showSuccess(BuildContext context, String message) {
    _show(
      context: context,
      message: message,
      icon: Icons.check_circle_outline,
      accentColor: Colors.greenAccent,
      bgColor: Colors.green.withValues(alpha: 0.25),
    );
  }

  static void showInfo(BuildContext context, String message) {
    _show(
      context: context,
      message: message,
      icon: Icons.info_outline,
      accentColor: Colors.cyanAccent,
      bgColor: Colors.blue.withValues(alpha: 0.25),
    );
  }

  static void showWarning(BuildContext context, String message) {
    _show(
      context: context,
      message: message,
      icon: Icons.warning_amber_rounded,
      accentColor: Colors.amberAccent,
      bgColor: Colors.orange.withValues(alpha: 0.25),
    );
  }

  static void showError(BuildContext context, String message) {
    _show(
      context: context,
      message: message,
      icon: Icons.delete_outline,
      accentColor: Colors.redAccent,
      bgColor: Colors.red.withValues(alpha: 0.25),
    );
  }

  static void _show({
    required BuildContext context,
    required String message,
    required IconData icon,
    required Color accentColor,
    required Color bgColor,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.2),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(icon, color: accentColor, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
