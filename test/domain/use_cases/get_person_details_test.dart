import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tmdb/data/models/person_details_model.dart';
import 'package:tmdb/data/repositories/person_details_repository.dart';
import 'package:tmdb/domain/use_cases/get_person_details.dart';

import 'get_person_details_test.mocks.dart';

@GenerateMocks([PersonDetailsRepository])
void main() {
  group('GetPersonDetails', () {
    late GetPersonDetails useCase;
    late MockPersonDetailsRepository mockRepository;

    setUp(() {
      mockRepository = MockPersonDetailsRepository();
      useCase = GetPersonDetails(repository: mockRepository);
    });

    test('should return person details from repository', () async {
      // Arrange
      final personDetails = PersonDetailsModel(
        id: 123,
        name: 'John Doe',
        biography: 'Great actor',
        gender: 2,
        popularity: 85.5,
      );
      when(
        mockRepository.getPersonDetails(123),
      ).thenAnswer((_) async => personDetails);

      // Act
      final result = await useCase.call(123);

      // Assert
      expect(result, equals(personDetails));
      verify(mockRepository.getPersonDetails(123)).called(1);
    });

    test('should pass through exceptions from repository', () async {
      // Arrange
      when(
        mockRepository.getPersonDetails(123),
      ).thenThrow(Exception('API Error'));

      // Act & Assert
      expect(() => useCase.call(123), throwsException);
      verify(mockRepository.getPersonDetails(123)).called(1);
    });
  });
}
