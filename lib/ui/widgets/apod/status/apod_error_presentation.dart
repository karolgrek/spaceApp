import 'package:flutter/material.dart';
import 'package:space_app/providers/daily_picture_provider.dart';

class ApodErrorPresentation {
  final IconData icon;
  final Color color;
  final String title;

  const ApodErrorPresentation({
    required this.icon,
    required this.color,
    required this.title,
  });

  factory ApodErrorPresentation.resolve(
    ApodErrorType type, {
    bool isWarning = false,
  }) {
    switch (type) {
      case ApodErrorType.noInternet:
        return ApodErrorPresentation(
          icon: Icons.wifi_off_rounded,
          color: isWarning ? Colors.orangeAccent : Colors.redAccent,
          title: "No Internet Connection",
        );
      case ApodErrorType.rateLimit:
        return const ApodErrorPresentation(
          icon: Icons.speed_rounded,
          color: Colors.amberAccent,
          title: "NASA Rate Limit Reached",
        );
      case ApodErrorType.serverError:
        return ApodErrorPresentation(
          icon: Icons.cloud_off_rounded,
          color: isWarning ? Colors.orangeAccent : Colors.redAccent,
          title: "NASA Service Unavailable",
        );
      case ApodErrorType.timeout:
        return const ApodErrorPresentation(
          icon: Icons.timer_outlined,
          color: Colors.orangeAccent,
          title: "Connection Timed Out",
        );
      case ApodErrorType.generic:
        return ApodErrorPresentation(
          icon: Icons.satellite_alt_rounded,
          color: isWarning ? Colors.orangeAccent : Colors.redAccent,
          title: isWarning ? "Connection Issue" : "Lost Connection in Deep Space!",
        );
    }
  }
}
