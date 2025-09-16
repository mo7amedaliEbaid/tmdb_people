import 'package:hive/hive.dart';

import '../data_sources/tmdb_api.dart';
import '../models/person_model.dart';

class PersonRepository {
  final TmdbApi tmdbApi;
  final Box? cacheBox;

  PersonRepository({required this.tmdbApi, this.cacheBox});

  Future<List<PersonModel>> getPopularPeople({int page = 1}) async {
    final people = await tmdbApi.getPopularPeople(page: page);
    if (page == 1 && cacheBox != null) {
      // store as list of PersonModel (Hive can store the objects directly)
      await cacheBox!.put('popular_people', people);
    }
    return people;
  }

  Future<List<PersonModel>> getCachedPopularPeople() async {
    if (cacheBox == null) return [];
    final raw = cacheBox!.get('popular_people');
    if (raw == null) return [];
    // raw is stored as List<PersonModel>
    return (raw as List).cast<PersonModel>();
  }

  Future<Map<String, dynamic>> getPersonDetails(int id) =>
      tmdbApi.getPersonDetails(id);

  Future<List<String>> getPersonImages(int id) async {
    final images = await tmdbApi.getPersonImages(id);
    return images.map((image) => image['file_path'] as String).toList();
  }
}
