import 'package:flutter/material.dart';
import 'package:my_news_app/models/article.dart';
import 'package:my_news_app/service/news_service.dart';

class NewsProvider extends ChangeNotifier {
  final NewsService _newsService = NewsService();
  
  List<Article> _articles = [];
  List<Article> get articles => _articles;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String _error = '';
  String get error => _error;

  Future<void> fetchTopHeadlines() async {
    _setLoading(true);
    _clearError();
    
    try {
      _articles = await _newsService.getTopHeadlines();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchNews(String query) async {
    if (query.isEmpty) {
      await fetchTopHeadlines();
      return;
    }
    
    _setLoading(true);
    _clearError();
    
    try {
      _articles = await _newsService.searchNews(query);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = '';
    notifyListeners();
  }
}

