import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tmdb/data/models/person_model.dart';
import 'package:tmdb/data/repositories/person_repository.dart';
import 'package:tmdb/domain/use_cases/get_cached_popular_people.dart';

import 'get_cached_popular_people_test.mocks.dart';

@GenerateMocks([PersonRepository])
void main() {
  group('GetCachedPopularPeople', () {
    late GetCachedPopularPeople useCase;
    late MockPersonRepository mockRepository;

    setUp(() {
      mockRepository = MockPersonRepository();
      useCase = GetCachedPopularPeople(mockRepository);
    });

    test('should return cached people from repository', () async {
      // Arrange
      final cachedPeople = [
        PersonModel(id: 1, name: 'John Doe', profilePath: '/john.jpg'),
        PersonModel(id: 2, name: 'Jane Doe', profilePath: '/jane.jpg'),
      ];
      when(
        mockRepository.getCachedPopularPeople(),
      ).thenAnswer((_) async => cachedPeople);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, equals(cachedPeople));
      verify(mockRepository.getCachedPopularPeople()).called(1);
    });

    test('should return empty list when no cached data', () async {
      // Arrange
      when(
        mockRepository.getCachedPopularPeople(),
      ).thenAnswer((_) async => <PersonModel>[]);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isEmpty);
      verify(mockRepository.getCachedPopularPeople()).called(1);
    });

    test('should pass through exceptions from repository', () async {
      // Arrange
      when(
        mockRepository.getCachedPopularPeople(),
      ).thenThrow(Exception('Cache Error'));

      // Act & Assert
      expect(() => useCase.call(), throwsException);
      verify(mockRepository.getCachedPopularPeople()).called(1);
    });
  });
}
