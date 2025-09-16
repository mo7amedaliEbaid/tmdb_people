import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tmdb/data/models/person_details_model.dart';
import 'package:tmdb/data/repositories/person_details_repository.dart';
import 'package:tmdb/domain/use_cases/get_cached_person_details.dart';

import 'get_cached_person_details_test.mocks.dart';

@GenerateMocks([PersonDetailsRepository])
void main() {
  group('GetCachedPersonDetails', () {
    late GetCachedPersonDetails useCase;
    late MockPersonDetailsRepository mockRepository;

    setUp(() {
      mockRepository = MockPersonDetailsRepository();
      useCase = GetCachedPersonDetails(repository: mockRepository);
    });

    test('should return cached person details from repository', () async {
      // Arrange
      final cachedDetails = PersonDetailsModel(
        id: 123,
        name: 'John Doe',
        biography: 'Great actor',
        gender: 2,
        popularity: 85.5,
      );
      when(
        mockRepository.getCachedPersonDetails(123),
      ).thenAnswer((_) async => cachedDetails);

      // Act
      final result = await useCase.call(123);

      // Assert
      expect(result, equals(cachedDetails));
      verify(mockRepository.getCachedPersonDetails(123)).called(1);
    });

    test('should return null when no cached data', () async {
      // Arrange
      when(
        mockRepository.getCachedPersonDetails(123),
      ).thenAnswer((_) async => null);

      // Act
      final result = await useCase.call(123);

      // Assert
      expect(result, isNull);
      verify(mockRepository.getCachedPersonDetails(123)).called(1);
    });

    test('should pass through exceptions from repository', () async {
      // Arrange
      when(
        mockRepository.getCachedPersonDetails(123),
      ).thenThrow(Exception('Cache Error'));

      // Act & Assert
      expect(() => useCase.call(123), throwsException);
      verify(mockRepository.getCachedPersonDetails(123)).called(1);
    });
  });
}
