import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb/data/models/person_model.dart';

void main() {
  group('PersonModel', () {
    test('should create PersonModel from JSON correctly', () {
      // Arrange
      final json = {
        'id': 123,
        'name': 'John Doe',
        'profile_path': '/profile.jpg',
      };

      // Act
      final person = PersonModel.fromJson(json);

      // Assert
      expect(person.id, equals(123));
      expect(person.name, equals('John Doe'));
      expect(person.profilePath, equals('/profile.jpg'));
    });

    test('should create PersonModel with null profile_path', () {
      // Arrange
      final json = {
        'id': 456,
        'name': 'Jane Doe',
        'profile_path': null,
      };

      // Act
      final person = PersonModel.fromJson(json);

      // Assert
      expect(person.id, equals(456));
      expect(person.name, equals('Jane Doe'));
      expect(person.profilePath, isNull);
    });

    test('should convert PersonModel to JSON correctly', () {
      // Arrange
      final person = PersonModel(
        id: 789,
        name: 'Test Person',
        profilePath: '/test.jpg',
      );

      // Act
      final json = person.toJson();

      // Assert
      expect(json['id'], equals(789));
      expect(json['name'], equals('Test Person'));
      expect(json['profile_path'], equals('/test.jpg'));
    });

    test('should handle missing fields in JSON', () {
      // Arrange
      final json = {
        'id': 999,
        'name': 'Minimal Person',
      };

      // Act
      final person = PersonModel.fromJson(json);

      // Assert
      expect(person.id, equals(999));
      expect(person.name, equals('Minimal Person'));
      expect(person.profilePath, isNull);
    });
  });
}
