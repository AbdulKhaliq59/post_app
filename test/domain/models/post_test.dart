import 'package:flutter_test/flutter_test.dart';
import 'package:post_app/domain/models/post.dart';

void main() {
  group('Post', () {
    test('Should create Post from valid JSON', () {
      // Arrange
      final json = {
        'title': 'Test',
        'author': 'Author',
        'description': 'Desc',
        'url': 'http://url',
        'urlToImage': 'http://img',
        'publishedAt': '2025-06-20T12:00:00Z',
      };
      // Act
      final post = Post.fromJson(json);
      // Assert
      expect(post.title, 'Test');
      expect(post.author, 'Author');
      expect(post.description, 'Desc');
      expect(post.url, 'http://url');
      expect(post.imageUrl, 'http://img');
      expect(post.publishedAt, DateTime.parse('2025-06-20T12:00:00Z'));
    });

    test('Should handle null publishedAt in JSON', () {
      // Arrange
      final json = {
        'title': 'Test',
        'author': 'Author',
        'description': 'Desc',
        'url': 'http://url',
        'urlToImage': 'http://img',
        'publishedAt': null,
      };
      // Act
      final post = Post.fromJson(json);
      // Assert
      expect(post.publishedAt, null);
    });

    test('Should return formattedPublishedAt correctly', () {
      // Arrange
      final post = Post(
        title: '',
        author: '',
        description: '',
        url: '',
        imageUrl: '',
        publishedAt: DateTime(2025, 6, 20, 12, 0),
      );
      // Act
      final formatted = post.formattedPublishedAt;
      // Assert
      expect(formatted, '2025-06-20 12:00');
    });

    test(
      'Should return null for formattedPublishedAt if publishedAt is null',() {
        // Arrange
        final post = Post(
          title: '',
          author: '',
          description: '',
          url: '',
          imageUrl: '',
          publishedAt: null,
        );
        // Act
        final formatted = post.formattedPublishedAt;
        // Assert
        expect(formatted, null);
      },
    );
  });
}
