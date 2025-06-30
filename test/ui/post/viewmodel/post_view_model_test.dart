import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:post_app/data/repositories/post_repository.dart';
import 'package:post_app/domain/models/post.dart';
import 'package:post_app/ui/post/viewmodel/post_view_model.dart';
import 'package:post_app/utils/result.dart';

import 'post_view_model.mocks.dart';

@GenerateMocks([IPostRepository])
void main() {
  group("PostViewModel", () {
    late PostViewModel viewModel;
    late MockIPostRepository mockRepository;

    setUp(() {
      mockRepository = MockIPostRepository();
      viewModel = PostViewModel(mockRepository);
    });

    tearDown(() {
      viewModel.dispose();
    });

    group("Initialization", () {
      test("should initialize fetchPostCommad", () {
        expect(viewModel.fetchPostCommand, isNotNull);
        expect(viewModel.fetchPostCommand.running, isFalse);
        expect(viewModel.fetchPostCommand.completed, isFalse);
        expect(viewModel.fetchPostCommand.error, isFalse);
        expect(viewModel.fetchPostCommand.result, isNull);
      });
    });

    group("fetchPosts", () {
      final testPosts = [
        Post(
          title: 'Test Post 1',
          author: 'Author 1',
          description: 'Description 1',
          url: 'https://example.com/1',
          imageUrl: 'https://example.com/image1.jpg',
          publishedAt: DateTime(2024, 1, 1),
        ),
        Post(
          title: 'Test Post 2',
          author: 'Author 2',
          description: 'Description 2',
          url: 'https://example.com/2',
          imageUrl: 'https://example.com/image2.jpg',
          publishedAt: DateTime(2024, 1, 2),
        ),
      ];

      test("should fetch posts successfully", () async {
        // Arrange
        when(mockRepository.getPosts()).thenAnswer((_) async => testPosts);

        // Act
        await viewModel.fetchPostCommand.execute();

        // Assert
        verify(mockRepository.getPosts()).called(1);
        expect(viewModel.fetchPostCommand.completed, isTrue);
        expect(viewModel.fetchPostCommand.error, isFalse);
        expect(viewModel.fetchPostCommand.running, isFalse);

        final result = viewModel.fetchPostCommand.result;
        expect(result, isA<Ok<List<Post>>>());
        expect((result as Ok<List<Post>>).value, equals(testPosts));
      });

      test("should handle repository exception", () async {
        // Arrange
        const errorMessage = 'Network error';

        when(mockRepository.getPosts()).thenThrow(Exception(errorMessage));

        // Act
        await viewModel.fetchPostCommand.execute();

        // Assert
        verify(mockRepository.getPosts()).called(1);
        expect(viewModel.fetchPostCommand.completed, isFalse);
        expect(viewModel.fetchPostCommand.error, isTrue);
        expect(viewModel.fetchPostCommand.running, isFalse);

        final result = viewModel.fetchPostCommand.result;
        expect(result, isA<Error<List<Post>>>());
        final errorResult = result as Error<List<Post>>;
        expect(errorResult.error.toString(), contains('Failed to fetch posts'));
        expect(errorResult.error.toString(), contains(errorMessage));
      });

      test("should handle empty posts list", () async {
        // Arrange
        when(mockRepository.getPosts()).thenAnswer((_) async => <Post>[]);

        // Act
        await viewModel.fetchPostCommand.execute();

        // Assert
        verify(mockRepository.getPosts()).called(1);
        expect(viewModel.fetchPostCommand.completed, isTrue);
        expect(viewModel.fetchPostCommand.error, isFalse);

        final result = viewModel.fetchPostCommand.result;
        expect(result, isA<Ok<List<Post>>>());
        expect((result as Ok<List<Post>>).value, isEmpty);
      });

      test("should not execute multiple times concurrently", () async {
        // Arrange
        when(mockRepository.getPosts()).thenAnswer((_) async => testPosts);

        // Act
        final future1 = viewModel.fetchPostCommand.execute();
        final future2 = viewModel.fetchPostCommand.execute();

        await Future.wait([future1, future2]);

        //Assert
        verify(mockRepository.getPosts()).called(1);
      });

      test("should update running state during execution", () async {
        // Arrange
        when(mockRepository.getPosts()).thenAnswer((_) async {
          await Future.delayed(
            Duration(milliseconds: 50),
          ); // Simulate network delay
          return testPosts;
        });

        // Act & Assert
        expect(viewModel.fetchPostCommand.running, isFalse);

        final future = viewModel.fetchPostCommand.execute();

        expect(viewModel.fetchPostCommand.running, isTrue);

        await future;

        expect(viewModel.fetchPostCommand.running, isFalse);
      });

      test("should clear result when clearResult is called", () async {
        // Arrange
        when(mockRepository.getPosts()).thenAnswer((_) async => testPosts);

        // Act
        await viewModel.fetchPostCommand.execute();
        expect(viewModel.fetchPostCommand.result, isNotNull);

        viewModel.fetchPostCommand.clearResult();

        // Assert

        expect(viewModel.fetchPostCommand.result, isNull);
        expect(viewModel.fetchPostCommand.completed, isFalse);
        expect(viewModel.fetchPostCommand.error, isFalse);
      });
    });

    group('ChangeNotifier behavior', () {
      test('should notify listeners when command state changes', () async {
        // Arrange
        when(mockRepository.getPosts()).thenAnswer((_) async => <Post>[]);

        int notificationCount = 0;
        viewModel.fetchPostCommand.addListener(() {
          notificationCount++;
        });

        // Act
        await viewModel.fetchPostCommand.execute();

        // Assert
        // Should be notified at least twice: once when execution starts, once when it completes
        expect(notificationCount, greaterThanOrEqualTo(2));
      });

      test('should notify listeners when result is cleared', () async {
        // Arrange
        when(mockRepository.getPosts()).thenAnswer((_) async => <Post>[]);

        await viewModel.fetchPostCommand.execute();

        bool notified = false;
        viewModel.fetchPostCommand.addListener(() {
          notified = true;
        });

        // Act
        viewModel.fetchPostCommand.clearResult();

        // Assert
        expect(notified, isTrue);
      });

      test(
        'should notify listeners during command execution lifecycle',
        () async {
          // Arrange
          when(mockRepository.getPosts()).thenAnswer((_) async {
            await Future.delayed(const Duration(milliseconds: 10));
            return <Post>[];
          });

          final notifications = <String>[];
          viewModel.fetchPostCommand.addListener(() {
            if (viewModel.fetchPostCommand.running) {
              notifications.add('running');
            } else if (viewModel.fetchPostCommand.completed) {
              notifications.add('completed');
            }
          });

          // Act
          await viewModel.fetchPostCommand.execute();

          // Assert
          expect(notifications, contains('running'));
          expect(notifications, contains('completed'));
        },
      );
    });
    group("edge cases", () {
      test(
        "should handle null values in repository response gracefully",
        () async {
          when(mockRepository.getPosts()).thenAnswer((_) async => <Post>[]);

          await viewModel.fetchPostCommand.execute();

          expect(viewModel.fetchPostCommand.completed, isTrue);
          final result = viewModel.fetchPostCommand.result as Ok<List<Post>>;

          expect(result.value, isNotNull);
          expect(result.value, isEmpty);
        },
      );
      test('should handle various exception types', () async {
        const exceptions = [
          'Network error',
          'HTTP 500 error',
          'JSON parsing error',
        ];

        for (final exceptionMessage in exceptions) {
          // Arrange
          when(
            mockRepository.getPosts(),
          ).thenThrow(Exception(exceptionMessage));

          // Act
          await viewModel.fetchPostCommand.execute();
          // Assert
          expect(viewModel.fetchPostCommand.error, isTrue);

          final result = viewModel.fetchPostCommand.result as Error<List<Post>>;
          expect(result.error.toString(), contains(exceptionMessage));

          viewModel.fetchPostCommand.clearResult();
        }
      });
    });
  });
}
