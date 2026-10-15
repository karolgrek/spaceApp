import 'package:flutter/material.dart';
import 'package:space_app/utils/app_colors.dart';
import 'apod_download_button.dart';

class ApodMetadataSection extends StatelessWidget {
  final String? date;
  final String? copyright;
  final String? imageUrl;
  final String? title;
  final bool isVideo;

  const ApodMetadataSection({
    super.key,
    this.date,
    this.copyright,
    this.imageUrl,
    this.title,
    this.isVideo = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasDate = date != null && date!.isNotEmpty;
    final hasImage = !isVideo && imageUrl != null && imageUrl!.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasDate || hasImage)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (hasDate)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.cardSecondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        date!,
                        style: const TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              if (hasImage)
                ApodDownloadButton(
                  imageUrl: imageUrl!,
                  date: date,
                  title: title,
                ),
            ],
          ),
        if (copyright != null && copyright!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.cardSecondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(Icons.copyright, size: 14, color: Colors.grey),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    copyright!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
