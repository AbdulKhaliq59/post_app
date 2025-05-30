class Post {
  final String title;
  final String? author;
  final String description;
  final String url;
  final String imageUrl;
  final DateTime? publishedAt;

  Post({
    required this.title,
    required this.author,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
  });
  String? get formattedPublishedAt {
    if (publishedAt == null) return null;
    return "${publishedAt!.year}-${publishedAt!.month.toString().padLeft(2, '0')}-${publishedAt!.day.toString().padLeft(2, '0')} "
        "${publishedAt!.hour.toString().padLeft(2, '0')}:${publishedAt!.minute.toString().padLeft(2, '0')}";
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['urlToImage'] ?? '',
      publishedAt:
          json['publishedAt'] != null
              ? DateTime.tryParse(json['publishedAt'])
              : null,
    );
  }
}
