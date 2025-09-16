class PersonDetails {
  final int id;
  final String name;
  final String? biography;
  final String? birthday;
  final String? deathday;
  final int gender;
  final String? homepage;
  final String? imdbId;
  final String? knownForDepartment;
  final String? placeOfBirth;
  final double popularity;
  final String? profilePath;
  final List<String> alsoKnownAs;

  PersonDetails({
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
  });
}
