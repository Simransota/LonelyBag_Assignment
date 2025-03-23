import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_news_app/models/article.dart';

class NewsService {
  static const String _baseUrl = 'https://newsapi.org/v2/';
  static const String _apiKey = '5eafc30e3ab3478892f55fc1f46e2110'; // Replace with your actual API key

  Future<List<Article>> getTopHeadlines({String country = 'us'}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/top-headlines?country=$country&apiKey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> articles = data['articles'];
        return articles.map((article) => Article.fromJson(article)).toList();
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }

  Future<List<Article>> searchNews(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/everything?q=$query&apiKey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> articles = data['articles'];
        return articles.map((article) => Article.fromJson(article)).toList();
      } else {
        throw Exception('Failed to search news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search news: $e');
    }
  }
}

