import 'package:cloud_firestore/cloud_firestore.dart';

class NewsModel {
  final String id;
  final String title;
  final String description;

  // Main Fields
  final String imageUrl;
  final String category;
  final DateTime publishedAt;

  // Compatibility Fields
  final String image;
  final String source;
  final String url;

  const NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.publishedAt,
    this.image = '',
    this.source = '',
    this.url = '',
  });

  factory NewsModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime date;

    final value = map['publishedAt'];

    if (value is Timestamp) {
      date = value.toDate();
    } else {
      date = DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
    }

    return NewsModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      publishedAt: date,

      // Compatibility
      image: map['image'] ?? map['imageUrl'] ?? '',
      source: map['source'] ?? '',
      url: map['url'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'publishedAt': Timestamp.fromDate(publishedAt),

      // Compatibility
      'image': image,
      'source': source,
      'url': url,
    };
  }

  NewsModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? category,
    DateTime? publishedAt,
    String? image,
    String? source,
    String? url,
  }) {
    return NewsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      publishedAt: publishedAt ?? this.publishedAt,
      image: image ?? this.image,
      source: source ?? this.source,
      url: url ?? this.url,
    );
  }
}