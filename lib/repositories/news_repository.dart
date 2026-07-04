import '../models/news_model.dart';
import '../services/news_service.dart';

class NewsRepository {
  final NewsService newsService;

  NewsRepository({
    required this.newsService,
  });

  // Get News
  Future<List<NewsModel>> getNews() {
    return newsService.getNews();
  }

  // Live Stream
  Stream<List<NewsModel>> newsStream() {
    return newsService.newsStream();
  }

  // Add News
  Future<void> addNews(NewsModel news) {
    return newsService.addNews(news);
  }

  // Update News
  Future<void> updateNews(NewsModel news) {
    return newsService.updateNews(news);
  }

  // Delete News
  Future<void> deleteNews(String id) {
    return newsService.deleteNews(id);
  }
}