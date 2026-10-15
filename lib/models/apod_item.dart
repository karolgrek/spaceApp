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
    final imageUrl = (isVideo ? (map['thumbnail_url'] ?? map['url']) : map['url'])
            ?.toString() ??
        '';

    final rawCopyright = map['copyright']?.toString();
    final copyright = rawCopyright?.replaceAll('\n', ' ').trim();

    return ApodItem(
      title: map['title']?.toString() ?? 'Astronomy Picture of the Day',
      explanation: map['explanation']?.toString() ?? '',
      date: map['date']?.toString() ?? '',
      copyright: (copyright != null && copyright.isNotEmpty) ? copyright : null,
      imageUrl: imageUrl,
      videoUrl: map['video_url']?.toString() ?? (isVideo ? map['url']?.toString() : null),
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
        'thumbnail_url': isVideo ? imageUrl : null,
        'video_url': videoUrl,
        'media_type': isVideo ? 'video' : 'image',
      };

  ApodItem copyWith({
    String? title,
    String? explanation,
    String? date,
    String? copyright,
    String? imageUrl,
    String? videoUrl,
    bool? isVideo,
  }) {
    return ApodItem(
      title: title ?? this.title,
      explanation: explanation ?? this.explanation,
      date: date ?? this.date,
      copyright: copyright ?? this.copyright,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      isVideo: isVideo ?? this.isVideo,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApodItem &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          explanation == other.explanation &&
          date == other.date &&
          copyright == other.copyright &&
          imageUrl == other.imageUrl &&
          videoUrl == other.videoUrl &&
          isVideo == other.isVideo;

  @override
  int get hashCode =>
      title.hashCode ^
      explanation.hashCode ^
      date.hashCode ^
      copyright.hashCode ^
      imageUrl.hashCode ^
      videoUrl.hashCode ^
      isVideo.hashCode;
}
