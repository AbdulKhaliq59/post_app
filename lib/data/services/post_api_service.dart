import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:post_app/domain/models/post.dart';
import "package:dio/dio.dart";
import 'package:post_app/ui/core/constants/api_constants.dart';
import 'package:post_app/ui/core/constants/error_messages.dart';

abstract class IPostApiService {
  Future<List<Post>> fetchPosts();
}

class PostApiService implements IPostApiService {
  final Dio _dio;
  PostApiService({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Future<List<Post>> fetchPosts() async {
    final apiKey = dotenv.env[kApiKeyEnv];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception(kApiKeyNotFoundError);
    }
    try {
      final response = await _dio.get(
        kBaseUrl,
        queryParameters: {
          'q': kQuery,
          'from': kFromDate,
          'to': kToDate,
          'sortBy': kSortBy,
          'apiKey': apiKey,
        },
      );

      final articles = response.data['articles'] as List;
      return articles.map((article) {
        return Post.fromJson(article);
      }).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'API Error: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        throw Exception('Network Error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected Error: $e');
    }
  }
}
