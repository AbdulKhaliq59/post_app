import 'package:post_app/data/services/post_api_service.dart';
import 'package:post_app/domain/models/post.dart';

class PostRepository {
  final PostApiService _apiService;

  PostRepository(this._apiService);

  Future<List<Post>> getPosts() async {
    return await _apiService.fetchPosts();
  }
}
