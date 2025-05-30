import 'package:flutter/material.dart';
import 'package:post_app/data/repositories/post_repository.dart';
import 'package:post_app/domain/models/post.dart';

class PostViewModel extends ChangeNotifier {
  final PostRepository _repository;

  PostViewModel(this._repository);

  List<Post> _posts = [];
  List<Post> get posts => _posts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _posts = await _repository.getPosts();
    } catch (e) {
      print(e);
    }
    _isLoading = false;
    notifyListeners();
  }
}
