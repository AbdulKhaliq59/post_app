import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:post_app/domain/models/post.dart';
import "package:http/http.dart" as http;

class PostApiService {
  final String _baseUrl = 'https://newsapi.org/v2/everything';

  Future<List<Post>> fetchPosts() async {
    final apiKey = dotenv.env['API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API_KEY not found in .env file');
    }

    final url = Uri.parse(
      '$_baseUrl?q=apple&from=2025-05-19&to=2025-05-19&sortBy=popularity&apiKey=$apiKey',
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
