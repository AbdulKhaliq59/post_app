import 'dart:convert';

import 'package:post_app/domain/models/post.dart';
import "package:http/http.dart" as http;

class PostApiService {
  final String _baseUrl = 'https://newsapi.org/v2/everything';
  final String _apiKey = '137dee1cfd874df88413635ec5406229';

  Future<List<Post>> fetchPosts() async {
    final url = Uri.parse(
      '$_baseUrl?q=apple&from=2025-05-19&to=2025-05-19&sortBy=popularity&apiKey=$_apiKey',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final articles = data['articles'] as List;
      return articles.map((article) => Post.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load post');
    }
  }
}
