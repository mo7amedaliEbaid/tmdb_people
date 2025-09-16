import 'package:hive/hive.dart';

import '../../domain/entities/person.dart';

part 'person_model.g.dart';

@HiveType(typeId: 0)
class PersonModel extends Person {
  @HiveField(0)
  @override
  final int id;

  @HiveField(1)
  @override
  final String name;

  @HiveField(2)
  @override
  final String? profilePath;

  PersonModel({required this.id, required this.name, this.profilePath})
    : super(id: id, name: name, profilePath: profilePath);

  factory PersonModel.fromJson(Map<String, dynamic> json) => PersonModel(
    id: json['id'] as int,
    name: json['name'] as String,
    profilePath: json['profile_path'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'profile_path': profilePath,
  };
}
