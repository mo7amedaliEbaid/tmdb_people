import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tmdb/data/models/person_image_model.dart';
import 'package:tmdb/data/repositories/person_details_repository.dart';
import 'package:tmdb/domain/use_cases/get_person_images.dart';

import 'get_person_images_test.mocks.dart';

@GenerateMocks([PersonDetailsRepository])
void main() {
  group('GetPersonImages', () {
    late GetPersonImages useCase;
    late MockPersonDetailsRepository mockRepository;

    setUp(() {
      mockRepository = MockPersonDetailsRepository();
      useCase = GetPersonImages(repository: mockRepository);
    });

    test('should return person images from repository', () async {
      // Arrange
      final images = [
        PersonImageModel(
          aspectRatio: 0.667,
          height: 3000,
          iso6391: null,
          filePath: '/image1.jpg',
          voteAverage: 5.5,
          voteCount: 100,
          width: 2000,
        ),
        PersonImageModel(
          aspectRatio: 1.0,
          height: 1500,
          iso6391: 'en',
          filePath: '/image2.jpg',
          voteAverage: 7.2,
          voteCount: 50,
          width: 1500,
        ),
      ];
      when(mockRepository.getPersonImages(123)).thenAnswer((_) async => images);

      // Act
      final result = await useCase.call(123);

      // Assert
      expect(result, equals(images));
      verify(mockRepository.getPersonImages(123)).called(1);
    });

    test('should return empty list when no images', () async {
      // Arrange
      when(
        mockRepository.getPersonImages(123),
      ).thenAnswer((_) async => <PersonImageModel>[]);

      // Act
      final result = await useCase.call(123);

      // Assert
      expect(result, isEmpty);
      verify(mockRepository.getPersonImages(123)).called(1);
    });

    test('should pass through exceptions from repository', () async {
      // Arrange
      when(
        mockRepository.getPersonImages(123),
      ).thenThrow(Exception('API Error'));

      // Act & Assert
      expect(() => useCase.call(123), throwsException);
      verify(mockRepository.getPersonImages(123)).called(1);
    });
  });
}
