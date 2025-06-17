import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:post_app/providers/post_providers.dart';
import 'package:post_app/ui/core/themes/app_theme.dart';
import 'package:post_app/ui/post/widgets/post_card.dart';
import 'package:post_app/utils/result.dart';

class PostScreen extends ConsumerWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(postViewModelProvider);
    final themeNotifier = ref.watch(themeProviderNotifier.notifier);

    final isDark = themeNotifier.isDark;

    debugPrint("DarkMode State: $isDark");
    final fetchCommand = viewModel.fetchPostCommand;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => themeNotifier.toggleTheme(),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (fetchCommand.running) {
            return const Center(child: CircularProgressIndicator());
          }

          final result = fetchCommand.result;
          debugPrint("Fetch command result: $result");
          if (result == null) {
            fetchCommand.execute();
            return const Center(child: Text("Loading posts..."));
          }

          return switch (result) {
            Ok<List> r => ListView.builder(
              itemCount: r.value.length,
              itemBuilder: (context, index) {
                return PostCard(post: r.value[index]);
              },
            ),
            Error() => Center(child: Text("Failed to load posts.")),
          };
        },
      ),
    );
  }
}
