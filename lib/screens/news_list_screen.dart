import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_news_app/providers/news_provider.dart';
import 'package:my_news_app/providers/theme_provider.dart';
import 'package:my_news_app/widget/news_card.dart';
import 'package:my_news_app/screens/news_detail_screen.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({Key? key}) : super(key: key);

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Fetch news when the screen loads
    Future.microtask(() => 
      Provider.of<NewsProvider>(context, listen: false).fetchTopHeadlines()
    );
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search news...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    newsProvider.fetchTopHeadlines();
                  },
                ),
              ),
              onSubmitted: (value) {
                newsProvider.searchNews(value);
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => newsProvider.fetchTopHeadlines(),
              child: Builder(
                builder: (context) {
                  if (newsProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (newsProvider.error.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error: ${newsProvider.error}',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => newsProvider.fetchTopHeadlines(),
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  if (newsProvider.articles.isEmpty) {
                    return const Center(
                      child: Text('No articles found'),
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: newsProvider.articles.length,
                    itemBuilder: (context, index) {
                      final article = newsProvider.articles[index];
                      return NewsCard(
                        article: article,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsDetailScreen(article: article),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

