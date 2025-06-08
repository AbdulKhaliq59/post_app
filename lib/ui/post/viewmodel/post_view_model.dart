import 'package:flutter/material.dart';
import 'package:post_app/data/repositories/post_repository.dart';
import 'package:post_app/domain/models/post.dart';
import 'package:post_app/utils/command.dart';
import 'package:post_app/utils/result.dart';

class PostViewModel extends ChangeNotifier {
  final PostRepository _repository;

  PostViewModel(this._repository) {
    fetchPostCommand = Command0<List<Post>>(_fetchPosts);
  }

  late final Command0<List<Post>> fetchPostCommand;

  Future<Result<List<Post>>> _fetchPosts() async {
    try {
      final posts = await _repository.getPosts();
      return Result.ok(posts);
    } catch (e) {
      return Result.error(Exception('Failed to fetch posts: $e'));
    }
  }
}
