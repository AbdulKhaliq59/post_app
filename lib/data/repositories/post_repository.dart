import 'package:post_app/data/services/post_api_service.dart';
import 'package:post_app/domain/models/post.dart';

abstract class IPostRepository {
  Future<List<Post>> getPosts();
}

class PostRepository implements IPostRepository {
  final IPostApiService _apiService;

  PostRepository(this._apiService);

  @override
  Future<List<Post>> getPosts() async {
    return await _apiService.fetchPosts();
  }
}
