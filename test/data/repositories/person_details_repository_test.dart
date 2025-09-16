import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:hive/hive.dart';
import 'package:tmdb/data/data_sources/tmdb_api.dart';
import 'package:tmdb/data/models/person_details_model.dart';
import 'package:tmdb/data/models/person_image_model.dart';
import 'package:tmdb/data/repositories/person_details_repository.dart';

import 'person_details_repository_test.mocks.dart';

@GenerateMocks([TmdbApi, Box])
void main() {
  group('PersonDetailsRepository', () {
    late PersonDetailsRepository repository;
    late MockTmdbApi mockTmdbApi;
    late MockBox mockCacheBox;

    setUp(() {
      mockTmdbApi = MockTmdbApi();
      mockCacheBox = MockBox();
      repository = PersonDetailsRepository(
        tmdbApi: mockTmdbApi,
        cacheBox: mockCacheBox,
      );
    });

    group('getPersonDetails', () {
      test('should return person details from API and cache them', () async {
        // Arrange
        final detailsJson = {
          'id': 123,
          'name': 'John Doe',
          'biography': 'Great actor',
          'gender': 2,
          'popularity': 85.5,
        };
        when(mockTmdbApi.getPersonDetails(123)).thenAnswer((_) async => detailsJson);

        // Act
        final result = await repository.getPersonDetails(123);

        // Assert
        expect(result.id, equals(123));
        expect(result.name, equals('John Doe'));
        expect(result.biography, equals('Great actor'));
        verify(mockTmdbApi.getPersonDetails(123)).called(1);
        verify(mockCacheBox.put('person_details_123', any)).called(1);
      });

      test('should work without cache box', () async {
        // Arrange
        final repositoryWithoutCache = PersonDetailsRepository(
          tmdbApi: mockTmdbApi,
          cacheBox: null,
        );
        final detailsJson = {
          'id': 123,
          'name': 'John Doe',
          'gender': 2,
          'popularity': 85.5,
        };
        when(mockTmdbApi.getPersonDetails(123)).thenAnswer((_) async => detailsJson);

        // Act
        final result = await repositoryWithoutCache.getPersonDetails(123);

        // Assert
        expect(result.id, equals(123));
        expect(result.name, equals('John Doe'));
        verify(mockTmdbApi.getPersonDetails(123)).called(1);
      });
    });

    group('getCachedPersonDetails', () {
      test('should return cached person details when available', () async {
        // Arrange
        final cachedDetails = PersonDetailsModel(
          id: 123,
          name: 'John Doe',
          gender: 2,
          popularity: 85.5,
        );
        when(mockCacheBox.get('person_details_123')).thenReturn(cachedDetails);

        // Act
        final result = await repository.getCachedPersonDetails(123);

        // Assert
        expect(result, equals(cachedDetails));
        verify(mockCacheBox.get('person_details_123')).called(1);
      });

      test('should return null when no cache available', () async {
        // Arrange
        when(mockCacheBox.get('person_details_123')).thenReturn(null);

        // Act
        final result = await repository.getCachedPersonDetails(123);

        // Assert
        expect(result, isNull);
        verify(mockCacheBox.get('person_details_123')).called(1);
      });

      test('should return null when cache box is null', () async {
        // Arrange
        final repositoryWithoutCache = PersonDetailsRepository(
          tmdbApi: mockTmdbApi,
          cacheBox: null,
        );

        // Act
        final result = await repositoryWithoutCache.getCachedPersonDetails(123);

        // Assert
        expect(result, isNull);
      });
    });

    group('getPersonImages', () {
      test('should return person images from API and cache them', () async {
        // Arrange
        final imagesJson = [
          {
            'aspect_ratio': 0.667,
            'height': 3000,
            'iso_639_1': null,
            'file_path': '/image1.jpg',
            'vote_average': 5.5,
            'vote_count': 100,
            'width': 2000,
          },
          {
            'aspect_ratio': 1.0,
            'height': 1500,
            'iso_639_1': 'en',
            'file_path': '/image2.jpg',
            'vote_average': 7.2,
            'vote_count': 50,
            'width': 1500,
          },
        ];
        when(mockTmdbApi.getPersonImages(123)).thenAnswer((_) async => imagesJson);

        // Act
        final result = await repository.getPersonImages(123);

        // Assert
        expect(result, hasLength(2));
        expect(result[0].filePath, equals('/image1.jpg'));
        expect(result[1].filePath, equals('/image2.jpg'));
        verify(mockTmdbApi.getPersonImages(123)).called(1);
        verify(mockCacheBox.put('person_images_123', any)).called(1);
      });

      test('should work without cache box', () async {
        // Arrange
        final repositoryWithoutCache = PersonDetailsRepository(
          tmdbApi: mockTmdbApi,
          cacheBox: null,
        );
        final imagesJson = [
          {
            'aspect_ratio': 0.667,
            'height': 3000,
            'iso_639_1': null,
            'file_path': '/image1.jpg',
            'vote_average': 5.5,
            'vote_count': 100,
            'width': 2000,
          },
        ];
        when(mockTmdbApi.getPersonImages(123)).thenAnswer((_) async => imagesJson);

        // Act
        final result = await repositoryWithoutCache.getPersonImages(123);

        // Assert
        expect(result, hasLength(1));
        expect(result[0].filePath, equals('/image1.jpg'));
        verify(mockTmdbApi.getPersonImages(123)).called(1);
      });
    });

    group('getCachedPersonImages', () {
      test('should return cached person images when available', () async {
        // Arrange
        final cachedImages = [
          PersonImageModel(
            aspectRatio: 0.667,
            height: 3000,
            iso6391: null,
            filePath: '/image1.jpg',
            voteAverage: 5.5,
            voteCount: 100,
            width: 2000,
          ),
        ];
        when(mockCacheBox.get('person_images_123')).thenReturn(cachedImages);

        // Act
        final result = await repository.getCachedPersonImages(123);

        // Assert
        expect(result, equals(cachedImages));
        verify(mockCacheBox.get('person_images_123')).called(1);
      });

      test('should return empty list when no cache available', () async {
        // Arrange
        when(mockCacheBox.get('person_images_123')).thenReturn(null);

        // Act
        final result = await repository.getCachedPersonImages(123);

        // Assert
        expect(result, isEmpty);
        verify(mockCacheBox.get('person_images_123')).called(1);
      });

      test('should return empty list when cache box is null', () async {
        // Arrange
        final repositoryWithoutCache = PersonDetailsRepository(
          tmdbApi: mockTmdbApi,
          cacheBox: null,
        );

        // Act
        final result = await repositoryWithoutCache.getCachedPersonImages(123);

        // Assert
        expect(result, isEmpty);
      });
    });
  });
}
