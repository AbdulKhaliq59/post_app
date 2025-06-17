import 'package:flutter/material.dart';
import 'package:post_app/ui/core/themes/app_theme.dart';
import 'package:post_app/ui/post/post_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeProvider = ref.watch(themeProviderNotifier);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider,
      home: const PostScreen(),
    );
  }
}
