import 'package:flutter/material.dart';
import 'package:post_app/ui/core/themes/app_theme.dart';
import 'package:post_app/ui/post/viewmodel/post_view_model.dart';
import 'package:post_app/ui/post/widgets/post_card.dart';
import 'package:provider/provider.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PostViewModel>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
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

      body:
          viewModel.isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: viewModel.posts.length,
                itemBuilder: (context, index) {
                  return PostCard(post: viewModel.posts[index]);
                },
              ),
    );
  }
}
