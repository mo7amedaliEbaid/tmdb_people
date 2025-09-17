import 'package:hive/hive.dart';

import '../../domain/entities/person_details.dart';

part 'person_details_model.g.dart';

@HiveType(typeId: 1)
class PersonDetailsModel extends PersonDetails {
  @HiveField(0)
  @override
  final int id;

  @HiveField(1)
  @override
  final String name;

  @HiveField(2)
  @override
  final String? biography;

  @HiveField(3)
  @override
  final String? birthday;

  @HiveField(4)
  @override
  final String? deathday;

  @HiveField(5)
  @override
  final int gender;

  @HiveField(6)
  @override
  final String? homepage;

  @HiveField(7)
  @override
  final String? imdbId;

  @HiveField(8)
  @override
  final String? knownForDepartment;

  @HiveField(9)
  @override
  final String? placeOfBirth;

  @HiveField(10)
  @override
  final double popularity;

  @HiveField(11)
  @override
  final String? profilePath;

  @HiveField(12)
  @override
  final List<String> alsoKnownAs;

  PersonDetailsModel({
    required this.id,
    required this.name,
    this.biography,
    this.birthday,
    this.deathday,
    required this.gender,
    this.homepage,
    this.imdbId,
    this.knownForDepartment,
    this.placeOfBirth,
    required this.popularity,
    this.profilePath,
    this.alsoKnownAs = const [],
  }) : super(
         id: id,
         name: name,
         biography: biography,
         birthday: birthday,
         deathday: deathday,
         gender: gender,
         homepage: homepage,
         imdbId: imdbId,
         knownForDepartment: knownForDepartment,
         placeOfBirth: placeOfBirth,
         popularity: popularity,
         profilePath: profilePath,
         alsoKnownAs: alsoKnownAs,
       );

  factory PersonDetailsModel.fromJson(Map<String, dynamic> json) {
    return PersonDetailsModel(
      id: json['id'] as int,
      name: json['name'] as String,
      biography: json['biography'] as String?,
      birthday: json['birthday'] as String?,
      deathday: json['deathday'] as String?,
      gender: json['gender'] as int,
      homepage: json['homepage'] as String?,
      imdbId: json['imdb_id'] as String?,
      knownForDepartment: json['known_for_department'] as String?,
      placeOfBirth: json['place_of_birth'] as String?,
      popularity: (json['popularity'] as num).toDouble(),
      profilePath: json['profile_path'] as String?,
      alsoKnownAs:
          (json['also_known_as'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'biography': biography,
    'birthday': birthday,
    'deathday': deathday,
    'gender': gender,
    'homepage': homepage,
    'imdb_id': imdbId,
    'known_for_department': knownForDepartment,
    'place_of_birth': placeOfBirth,
    'popularity': popularity,
    'profile_path': profilePath,
    'also_known_as': alsoKnownAs,
  };
}
