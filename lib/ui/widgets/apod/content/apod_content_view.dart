import 'package:flutter/material.dart';
import 'package:space_app/models/apod_item.dart';
import 'package:space_app/utils/app_colors.dart';
import 'apod_cached_banner.dart';
import 'apod_explanation_section.dart';
import 'apod_media_view.dart';
import 'apod_metadata_section.dart';

class ApodContentView extends StatelessWidget {
  final ApodItem item;
  final bool isCached;
  final String? cacheReason;
  final VoidCallback? onRetryOnline;

  ApodContentView({
    super.key,
    required Map<String, dynamic> data,
    this.isCached = false,
    this.cacheReason,
    this.onRetryOnline,
  }) : item = ApodItem.fromMap(data);

  const ApodContentView.item({
    super.key,
    required this.item,
    this.isCached = false,
    this.cacheReason,
    this.onRetryOnline,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCached)
            ApodCachedBanner(
              date: item.date,
              reason: cacheReason,
              onRetry: onRetryOnline,
            ),
          ApodMediaView.item(item: item),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                ),
                const SizedBox(height: 10),
                ApodMetadataSection(
                  date: item.date,
                  copyright: item.copyright,
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.divider),
                const SizedBox(height: 8),
                ApodExplanationSection(explanation: item.explanation),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
