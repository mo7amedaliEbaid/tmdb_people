import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb/data/models/person_image_model.dart';

void main() {
  group('PersonImageModel', () {
    test('should create PersonImageModel from JSON correctly', () {
      // Arrange
      final json = {
        'aspect_ratio': 0.667,
        'height': 3000,
        'iso_639_1': 'en',
        'file_path': '/image.jpg',
        'vote_average': 5.5,
        'vote_count': 100,
        'width': 2000,
      };

      // Act
      final personImage = PersonImageModel.fromJson(json);

      // Assert
      expect(personImage.aspectRatio, equals(0.667));
      expect(personImage.height, equals(3000));
      expect(personImage.iso6391, equals('en'));
      expect(personImage.filePath, equals('/image.jpg'));
      expect(personImage.voteAverage, equals(5.5));
      expect(personImage.voteCount, equals(100));
      expect(personImage.width, equals(2000));
    });

    test('should create PersonImageModel with null iso_639_1', () {
      // Arrange
      final json = {
        'aspect_ratio': 1.0,
        'height': 1500,
        'iso_639_1': null,
        'file_path': '/test.jpg',
        'vote_average': 0.0,
        'vote_count': 0,
        'width': 1500,
      };

      // Act
      final personImage = PersonImageModel.fromJson(json);

      // Assert
      expect(personImage.aspectRatio, equals(1.0));
      expect(personImage.height, equals(1500));
      expect(personImage.iso6391, isNull);
      expect(personImage.filePath, equals('/test.jpg'));
      expect(personImage.voteAverage, equals(0.0));
      expect(personImage.voteCount, equals(0));
      expect(personImage.width, equals(1500));
    });

    test('should convert PersonImageModel to JSON correctly', () {
      // Arrange
      final personImage = PersonImageModel(
        aspectRatio: 0.75,
        height: 2400,
        iso6391: 'fr',
        filePath: '/french_image.jpg',
        voteAverage: 7.2,
        voteCount: 250,
        width: 1800,
      );

      // Act
      final json = personImage.toJson();

      // Assert
      expect(json['aspect_ratio'], equals(0.75));
      expect(json['height'], equals(2400));
      expect(json['iso_639_1'], equals('fr'));
      expect(json['file_path'], equals('/french_image.jpg'));
      expect(json['vote_average'], equals(7.2));
      expect(json['vote_count'], equals(250));
      expect(json['width'], equals(1800));
    });
  });
}
