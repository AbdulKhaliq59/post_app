import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:post_app/data/repositories/post_repository.dart';
import 'package:post_app/data/services/post_api_service.dart';
import 'package:post_app/ui/post/viewmodel/post_view_model.dart';

final postApiServiceProvider = Provider<PostApiService>(
  (ref) => PostApiService(),
);

final postRepositoryProvider = Provider((ref) {
  final postApiService = ref.watch(postApiServiceProvider);
  return PostRepository(postApiService);
});

final postViewModelProvider = ChangeNotifierProvider((ref) {
  final repo = ref.watch(postRepositoryProvider);
  return PostViewModel(repo);
});
