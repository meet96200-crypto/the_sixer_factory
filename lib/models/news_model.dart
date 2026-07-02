class NewsModel {
  final String title;
  final String image;
  final String description;
  final String source;
  final String publishedAt;
  final String url;

  NewsModel({
    required this.title,
    required this.image,
    required this.description,
    required this.source,
    required this.publishedAt,
    required this.url,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json["title"] ?? "",
      image: json["urlToImage"] ?? "",
      description: json["description"] ?? "",
      source: json["source"]?["name"] ?? "",
      publishedAt: json["publishedAt"] ?? "",
      url: json["url"] ?? "",
    );
  }
}