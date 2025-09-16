import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tmdb/data/models/person_image_model.dart';
import 'package:tmdb/data/repositories/person_details_repository.dart';
import 'package:tmdb/domain/use_cases/get_cached_person_images.dart';

import 'get_cached_person_images_test.mocks.dart';

@GenerateMocks([PersonDetailsRepository])
void main() {
  group('GetCachedPersonImages', () {
    late GetCachedPersonImages useCase;
    late MockPersonDetailsRepository mockRepository;

    setUp(() {
      mockRepository = MockPersonDetailsRepository();
      useCase = GetCachedPersonImages(repository: mockRepository);
    });

    test('should return cached person images from repository', () async {
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
      when(
        mockRepository.getCachedPersonImages(123),
      ).thenAnswer((_) async => cachedImages);

      // Act
      final result = await useCase.call(123);

      // Assert
      expect(result, equals(cachedImages));
      verify(mockRepository.getCachedPersonImages(123)).called(1);
    });

    test('should return empty list when no cached data', () async {
      // Arrange
      when(
        mockRepository.getCachedPersonImages(123),
      ).thenAnswer((_) async => <PersonImageModel>[]);

      // Act
      final result = await useCase.call(123);

      // Assert
      expect(result, isEmpty);
      verify(mockRepository.getCachedPersonImages(123)).called(1);
    });

    test('should pass through exceptions from repository', () async {
      // Arrange
      when(
        mockRepository.getCachedPersonImages(123),
      ).thenThrow(Exception('Cache Error'));

      // Act & Assert
      expect(() => useCase.call(123), throwsException);
      verify(mockRepository.getCachedPersonImages(123)).called(1);
    });
  });
}
