class ApodItem {
  final String title;
  final String explanation;
  final String date;
  final String? copyright;
  final String imageUrl;
  final String? videoUrl;
  final bool isVideo;

  const ApodItem({
    required this.title,
    required this.explanation,
    required this.date,
    this.copyright,
    required this.imageUrl,
    this.videoUrl,
    this.isVideo = false,
  });

  factory ApodItem.fromMap(Map<String, dynamic> map) {
    final mediaType = map['media_type']?.toString().toLowerCase();
    final isVideo = mediaType == 'video';
    final imageUrl = (isVideo ? map['thumbnail_url'] : map['url'])
            ?.toString() ??
        map['url']?.toString() ??
        '';

    final rawCopyright = map['copyright']?.toString();
    final copyright = rawCopyright?.replaceAll('\n', ' ').trim();

    return ApodItem(
      title: map['title']?.toString() ?? 'Astronomy Picture of the Day',
      explanation: map['explanation']?.toString() ?? '',
      date: map['date']?.toString() ?? '',
      copyright: (copyright != null && copyright.isNotEmpty) ? copyright : null,
      imageUrl: imageUrl,
      videoUrl: isVideo ? map['url']?.toString() : null,
      isVideo: isVideo,
    );
  }

  const ApodItem.empty()
      : title = 'Astronomy Picture of the Day',
        explanation = '',
        date = '',
        copyright = null,
        imageUrl = '',
        videoUrl = null,
        isVideo = false;

  Map<String, dynamic> toMap() => {
        'title': title,
        'explanation': explanation,
        'date': date,
        'copyright': copyright,
        'url': imageUrl,
        'media_type': isVideo ? 'video' : 'image',
      };
}
