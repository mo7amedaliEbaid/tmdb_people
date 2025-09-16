import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb/data/models/person_details_model.dart';

void main() {
  group('PersonDetailsModel', () {
    test('should create PersonDetailsModel from JSON correctly', () {
      // Arrange
      final json = {
        'id': 123,
        'name': 'John Doe',
        'biography': 'A great actor',
        'birthday': '1990-01-01',
        'deathday': null,
        'gender': 2,
        'homepage': 'https://johndoe.com',
        'imdb_id': 'nm123456',
        'known_for_department': 'Acting',
        'place_of_birth': 'New York, USA',
        'popularity': 85.5,
        'profile_path': '/profile.jpg',
        'also_known_as': ['Johnny', 'JD'],
      };

      // Act
      final personDetails = PersonDetailsModel.fromJson(json);

      // Assert
      expect(personDetails.id, equals(123));
      expect(personDetails.name, equals('John Doe'));
      expect(personDetails.biography, equals('A great actor'));
      expect(personDetails.birthday, equals('1990-01-01'));
      expect(personDetails.deathday, isNull);
      expect(personDetails.gender, equals(2));
      expect(personDetails.homepage, equals('https://johndoe.com'));
      expect(personDetails.imdbId, equals('nm123456'));
      expect(personDetails.knownForDepartment, equals('Acting'));
      expect(personDetails.placeOfBirth, equals('New York, USA'));
      expect(personDetails.popularity, equals(85.5));
      expect(personDetails.profilePath, equals('/profile.jpg'));
      expect(personDetails.alsoKnownAs, equals(['Johnny', 'JD']));
    });

    test('should create PersonDetailsModel with minimal data', () {
      // Arrange
      final json = {
        'id': 456,
        'name': 'Jane Doe',
        'gender': 1,
        'popularity': 50.0,
      };

      // Act
      final personDetails = PersonDetailsModel.fromJson(json);

      // Assert
      expect(personDetails.id, equals(456));
      expect(personDetails.name, equals('Jane Doe'));
      expect(personDetails.biography, isNull);
      expect(personDetails.birthday, isNull);
      expect(personDetails.deathday, isNull);
      expect(personDetails.gender, equals(1));
      expect(personDetails.homepage, isNull);
      expect(personDetails.imdbId, isNull);
      expect(personDetails.knownForDepartment, isNull);
      expect(personDetails.placeOfBirth, isNull);
      expect(personDetails.popularity, equals(50.0));
      expect(personDetails.profilePath, isNull);
      expect(personDetails.alsoKnownAs, isEmpty);
    });

    test('should convert PersonDetailsModel to JSON correctly', () {
      // Arrange
      final personDetails = PersonDetailsModel(
        id: 789,
        name: 'Test Person',
        biography: 'Test biography',
        birthday: '1985-05-15',
        deathday: '2020-12-31',
        gender: 2,
        homepage: 'https://test.com',
        imdbId: 'nm789',
        knownForDepartment: 'Directing',
        placeOfBirth: 'Los Angeles, USA',
        popularity: 75.0,
        profilePath: '/test.jpg',
        alsoKnownAs: ['Test', 'TP'],
      );

      // Act
      final json = personDetails.toJson();

      // Assert
      expect(json['id'], equals(789));
      expect(json['name'], equals('Test Person'));
      expect(json['biography'], equals('Test biography'));
      expect(json['birthday'], equals('1985-05-15'));
      expect(json['deathday'], equals('2020-12-31'));
      expect(json['gender'], equals(2));
      expect(json['homepage'], equals('https://test.com'));
      expect(json['imdb_id'], equals('nm789'));
      expect(json['known_for_department'], equals('Directing'));
      expect(json['place_of_birth'], equals('Los Angeles, USA'));
      expect(json['popularity'], equals(75.0));
      expect(json['profile_path'], equals('/test.jpg'));
      expect(json['also_known_as'], equals(['Test', 'TP']));
    });
  });
}
