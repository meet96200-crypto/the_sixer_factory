import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsService {
  static const String apiKey = "1e1bd6f828e148629f4c178839d1324d";

  static const String url =
      "https://newsapi.org/v2/everything?q=cricket&language=en&sortBy=publishedAt&apiKey=$apiKey";

  Future<List<NewsModel>> getNews() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      final List articles = json["articles"];

      return articles
          .map((e) => NewsModel.fromJson(e))
          .where((news) =>
      news.title.isNotEmpty &&
          news.image.isNotEmpty)
          .toList();
    } else {
      throw Exception("Failed to load News");
    }
  }
}