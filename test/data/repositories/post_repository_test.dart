import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:post_app/data/repositories/post_repository.dart';
import 'package:post_app/data/services/post_api_service.dart';
import 'package:post_app/domain/models/post.dart';
@GenerateMocks([IPostApiService])
import 'post_repository_test.mocks.dart';

void main() {
  group('PostRepository Tests', () {
    late MockIPostApiService mockApiService;
    late IPostRepository postRepository;

    setUp(() {
      mockApiService = MockIPostApiService();
      postRepository = PostRepository(mockApiService);
    });

    group('getPosts', () {
      test("Should return list of posts when API call is successful", () async {
        final expectedPosts = [
          Post(
            title: 'Test Post 1',
            author: 'Author 1',
            description: 'Description 1',
            url: 'https://example.com/post1',
            imageUrl: 'https://example.com/image1.jpg',
            publishedAt: DateTime(2024, 1, 1, 12, 0),
          ),
          Post(
            title: 'Test Post 2',
            author: 'Author 2',
            description: 'Description 2',
            url: 'https://example.com/post2',
            imageUrl: 'https://example.com/image2.jpg',
            publishedAt: DateTime(2024, 1, 2, 15, 30),
          ),
        ];
        when(
          mockApiService.fetchPosts(),
        ).thenAnswer((_) async => expectedPosts);

        final result = await postRepository.getPosts();
        expect(result, equals(expectedPosts));
        expect(result.length, equals(2));
        expect(result[0].title, equals('Test Post 1'));
        expect(result[1].title, equals('Test Post 2'));
        verify(mockApiService.fetchPosts()).called(1);
      });

      test("should return empty list when API returns empty list", () async {
        when(mockApiService.fetchPosts()).thenAnswer((_) async => <Post>[]);

        final result = await postRepository.getPosts();
        expect(result, isEmpty);
        verify(mockApiService.fetchPosts()).called(1);
      });
      test(
        "should thrown exception when API service throws exception",
        () async {
          const errorMessage = 'API Error: 500 - Internal Server Error';
          when(mockApiService.fetchPosts()).thenThrow(Exception(errorMessage));

          expect(
            () async => await postRepository.getPosts(),
            throwsA(isA<Exception>()),
          );
          verify(mockApiService.fetchPosts()).called(1);
        },
      );
      test("should throw specific exception when API key is missing", () async {
        const errorMessage = 'Network Error: Connection timeout';
        when(mockApiService.fetchPosts()).thenThrow(Exception(errorMessage));

        expect(
          () async => await postRepository.getPosts(),
          throwsA(
            predicate(
              (e) => e is Exception && e.toString().contains('Network Error'),
            ),
          ),
        );
        verify(mockApiService.fetchPosts()).called(1);
      });

      test("should handle posts with null values correctly", () async {
        final postsWithNulls = [
          Post(
            title: 'Test Post',
            author: null,
            description: 'Description',
            url: 'https://example.com/post',
            imageUrl: 'https://example.com/image.jpg',
            publishedAt: null,
          ),
        ];

        when(
          mockApiService.fetchPosts(),
        ).thenAnswer((_) async => postsWithNulls);

        final result = await postRepository.getPosts();

        expect(result.length, equals(1));
        expect(result[0].author, isNull);
        expect(result[0].publishedAt, isNull);
        expect(result[0].title, equals('Test Post'));
        verify(mockApiService.fetchPosts()).called(1);
      });

      test(
        "should verify API service is called only once per request",
        () async {
          // Arrange
          final expectedPosts = [
            Post(
              title: 'Test Post',
              author: 'Author',
              description: 'Description',
              url: 'https://example.com/post',
              imageUrl: 'https://example.com/image.jpg',
              publishedAt: DateTime.now(),
            ),
          ];
          when(
            mockApiService.fetchPosts(),
          ).thenAnswer((_) async => expectedPosts);

          // Act
          await postRepository.getPosts();
          await postRepository
              .getPosts(); // Call again to check for multiple calls

          // Assert
          verify(mockApiService.fetchPosts()).called(2);
        },
      );
    });

    group("Integration with Post model", () {
      test("should handle posts with formatted dates correctly", () async {
        // Arrange
        final testDate = DateTime(2024, 1, 15, 14, 30);
        final posts = [
          Post(
            title: 'Test Post',
            author: 'Author',
            description: 'Description',
            url: 'https://example.com/post',
            imageUrl: 'https://example.com/image.jpg',
            publishedAt: testDate,
          ),
        ];
        when(mockApiService.fetchPosts()).thenAnswer((_) async => posts);

        // Act
        final result = await postRepository.getPosts();

        // Assert
        expect(result[0].formattedPublishedAt, equals('2024-01-15 14:30'));
        verify(mockApiService.fetchPosts()).called(1);
      });
    });
    tearDown(() {
      reset(mockApiService);
    });
  });
}
