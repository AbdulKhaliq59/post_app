import 'package:flutter/material.dart';
import 'package:post_app/ui/core/themes/app_theme.dart';
import 'package:post_app/ui/post/viewmodel/post_view_model.dart';
import 'package:post_app/ui/post/widgets/post_card.dart';
import 'package:post_app/utils/result.dart';
import 'package:provider/provider.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PostViewModel>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final fetchCommand = viewModel.fetchPostCommand;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
        actions: [
          Row(
            children: [
              const Icon(Icons.light_mode),
              Switch(
                value: themeProvider.isDark,
                onChanged: (val) {
                  themeProvider.toggleTheme();
                },
              ),
              const Icon(Icons.dark_mode),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (fetchCommand.running) {
            return const Center(child: CircularProgressIndicator());
          }

          final result = fetchCommand.result;
          if (result == null) {
            // No result yet, trigger fetch
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
