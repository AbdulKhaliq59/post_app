import 'package:flutter/material.dart';
import 'package:post_app/data/repositories/post_repository.dart';
import 'package:post_app/data/services/post_api_service.dart';
import 'package:post_app/ui/core/themes/app_theme.dart';
import 'package:post_app/ui/post/post_screen.dart';
import 'package:post_app/ui/post/viewmodel/post_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
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
        ChangeNotifierProvider(create: (_) => PostViewModel(postRepo)),
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
