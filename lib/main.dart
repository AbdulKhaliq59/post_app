import 'package:flutter/material.dart';
import 'package:post_app/data/repositories/post_repository.dart';
import 'package:post_app/data/services/post_api_service.dart';
import 'package:post_app/ui/core/themes/app_theme.dart';
import 'package:post_app/ui/post/post_screen.dart';
import 'package:post_app/ui/post/viewmodel/post_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final themeProvider = ThemeProvider();
  final postRepo = PostRepository(PostApiService());

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(
          create: (_) => PostViewModel(postRepo)..fetchPosts(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder:
            (context, theme, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme.theme,
              home: PostScreen(),
            ),
      ),
    );
  }
}
