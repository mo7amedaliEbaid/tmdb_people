import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:hive/hive.dart';
import 'package:tmdb/data/data_sources/tmdb_api.dart';
import 'package:tmdb/data/models/person_model.dart';
import 'package:tmdb/data/repositories/person_repository.dart';

import 'person_repository_test.mocks.dart';

@GenerateMocks([TmdbApi, Box])
void main() {
  group('PersonRepository', () {
    late PersonRepository repository;
    late MockTmdbApi mockTmdbApi;
    late MockBox mockCacheBox;

    setUp(() {
      mockTmdbApi = MockTmdbApi();
      mockCacheBox = MockBox();
      repository = PersonRepository(
        tmdbApi: mockTmdbApi,
        cacheBox: mockCacheBox,
      );
    });

    group('getPopularPeople', () {
      test('should return people from API and cache them for page 1', () async {
        // Arrange
        final people = [
          PersonModel(id: 1, name: 'John Doe', profilePath: '/john.jpg'),
          PersonModel(id: 2, name: 'Jane Doe', profilePath: '/jane.jpg'),
        ];
        when(mockTmdbApi.getPopularPeople(page: 1)).thenAnswer((_) async => people);

        // Act
        final result = await repository.getPopularPeople(page: 1);

        // Assert
        expect(result, equals(people));
        verify(mockTmdbApi.getPopularPeople(page: 1)).called(1);
        verify(mockCacheBox.put('popular_people', people)).called(1);
      });

      test('should return people from API without caching for page > 1', () async {
        // Arrange
        final people = [
          PersonModel(id: 3, name: 'Bob Smith', profilePath: '/bob.jpg'),
        ];
        when(mockTmdbApi.getPopularPeople(page: 2)).thenAnswer((_) async => people);

        // Act
        final result = await repository.getPopularPeople(page: 2);

        // Assert
        expect(result, equals(people));
        verify(mockTmdbApi.getPopularPeople(page: 2)).called(1);
        verifyNever(mockCacheBox.put(any, any));
      });

      test('should work without cache box', () async {
        // Arrange
        final repositoryWithoutCache = PersonRepository(
          tmdbApi: mockTmdbApi,
          cacheBox: null,
        );
        final people = [
          PersonModel(id: 1, name: 'John Doe', profilePath: '/john.jpg'),
        ];
        when(mockTmdbApi.getPopularPeople(page: 1)).thenAnswer((_) async => people);

        // Act
        final result = await repositoryWithoutCache.getPopularPeople(page: 1);

        // Assert
        expect(result, equals(people));
        verify(mockTmdbApi.getPopularPeople(page: 1)).called(1);
      });
    });

    group('getCachedPopularPeople', () {
      test('should return cached people when available', () async {
        // Arrange
        final cachedPeople = [
          PersonModel(id: 1, name: 'John Doe', profilePath: '/john.jpg'),
        ];
        when(mockCacheBox.get('popular_people')).thenReturn(cachedPeople);

        // Act
        final result = await repository.getCachedPopularPeople();

        // Assert
        expect(result, equals(cachedPeople));
        verify(mockCacheBox.get('popular_people')).called(1);
      });

      test('should return empty list when no cache available', () async {
        // Arrange
        when(mockCacheBox.get('popular_people')).thenReturn(null);

        // Act
        final result = await repository.getCachedPopularPeople();

        // Assert
        expect(result, isEmpty);
        verify(mockCacheBox.get('popular_people')).called(1);
      });

      test('should return empty list when cache box is null', () async {
        // Arrange
        final repositoryWithoutCache = PersonRepository(
          tmdbApi: mockTmdbApi,
          cacheBox: null,
        );

        // Act
        final result = await repositoryWithoutCache.getCachedPopularPeople();

        // Assert
        expect(result, isEmpty);
      });
    });

    group('getPersonDetails', () {
      test('should return person details from API', () async {
        // Arrange
        final details = {'id': 123, 'name': 'John Doe', 'biography': 'Great actor'};
        when(mockTmdbApi.getPersonDetails(123)).thenAnswer((_) async => details);

        // Act
        final result = await repository.getPersonDetails(123);

        // Assert
        expect(result, equals(details));
        verify(mockTmdbApi.getPersonDetails(123)).called(1);
      });
    });

    group('getPersonImages', () {
      test('should return person images from API', () async {
        // Arrange
        final images = [
          {'file_path': '/image1.jpg'},
          {'file_path': '/image2.jpg'},
        ];
        when(mockTmdbApi.getPersonImages(123)).thenAnswer((_) async => images);

        // Act
        final result = await repository.getPersonImages(123);

        // Assert
        expect(result, equals(['/image1.jpg', '/image2.jpg']));
        verify(mockTmdbApi.getPersonImages(123)).called(1);
      });
    });
  });
}
