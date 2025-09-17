import 'package:hive/hive.dart';

import '../../domain/entities/person_image.dart';

part 'person_image_model.g.dart';

@HiveType(typeId: 2)
class PersonImageModel extends PersonImage {
  @HiveField(0)
  @override
  final double aspectRatio;

  @HiveField(1)
  @override
  final int height;

  @HiveField(2)
  @override
  final String? iso6391;

  @HiveField(3)
  @override
  final String filePath;

  @HiveField(4)
  @override
  final double voteAverage;

  @HiveField(5)
  @override
  final int voteCount;

  @HiveField(6)
  @override
  final int width;

  PersonImageModel({
    required this.aspectRatio,
    required this.height,
    this.iso6391,
    required this.filePath,
    required this.voteAverage,
    required this.voteCount,
    required this.width,
  }) : super(
         aspectRatio: aspectRatio,
         height: height,
         iso6391: iso6391,
         filePath: filePath,
         voteAverage: voteAverage,
         voteCount: voteCount,
         width: width,
       );

  factory PersonImageModel.fromJson(Map<String, dynamic> json) {
    return PersonImageModel(
      aspectRatio: (json['aspect_ratio'] as num).toDouble(),
      height: json['height'] as int,
      iso6391: json['iso_639_1'] as String?,
      filePath: json['file_path'] as String,
      voteAverage: (json['vote_average'] as num).toDouble(),
      voteCount: json['vote_count'] as int,
      width: json['width'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'aspect_ratio': aspectRatio,
    'height': height,
    'iso_639_1': iso6391,
    'file_path': filePath,
    'vote_average': voteAverage,
    'vote_count': voteCount,
    'width': width,
  };
}
