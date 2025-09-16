import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:tmdb/data/models/person_model.dart';
import 'package:tmdb/data/repositories/person_repository.dart';
import 'package:tmdb/domain/use_cases/get_popular_people.dart';

import 'get_popular_people_test.mocks.dart';

@GenerateMocks([PersonRepository])
void main() {
  group('GetPopularPeople', () {
    late GetPopularPeople useCase;
    late MockPersonRepository mockRepository;

    setUp(() {
      mockRepository = MockPersonRepository();
      useCase = GetPopularPeople(mockRepository);
    });

    test('should return people from repository', () async {
      // Arrange
      final people = [
        PersonModel(id: 1, name: 'John Doe', profilePath: '/john.jpg'),
        PersonModel(id: 2, name: 'Jane Doe', profilePath: '/jane.jpg'),
      ];
      when(mockRepository.getPopularPeople(page: 1)).thenAnswer((_) async => people);

      // Act
      final result = await useCase.call(page: 1);

      // Assert
      expect(result, equals(people));
      verify(mockRepository.getPopularPeople(page: 1)).called(1);
    });

    test('should use default page 1 when no page specified', () async {
      // Arrange
      final people = [
        PersonModel(id: 1, name: 'John Doe', profilePath: '/john.jpg'),
      ];
      when(mockRepository.getPopularPeople(page: 1)).thenAnswer((_) async => people);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, equals(people));
      verify(mockRepository.getPopularPeople(page: 1)).called(1);
    });

    test('should pass through exceptions from repository', () async {
      // Arrange
      when(mockRepository.getPopularPeople(page: 1)).thenThrow(Exception('API Error'));

      // Act & Assert
      expect(() => useCase.call(page: 1), throwsException);
      verify(mockRepository.getPopularPeople(page: 1)).called(1);
    });
  });
}
