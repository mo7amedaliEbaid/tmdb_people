import 'package:hive/hive.dart';

import '../data_sources/tmdb_api.dart';
import '../models/person_details_model.dart';
import '../models/person_image_model.dart';

class PersonDetailsRepository {
  final TmdbApi tmdbApi;
  final Box? cacheBox;

  PersonDetailsRepository({required this.tmdbApi, this.cacheBox});

  Future<PersonDetailsModel> getPersonDetails(int id) async {
    final details = await tmdbApi.getPersonDetails(id);
    final personDetails = PersonDetailsModel.fromJson(details);
    
    if (cacheBox != null) {
      await cacheBox!.put('person_details_$id', personDetails);
    }
    
    return personDetails;
  }

  Future<PersonDetailsModel?> getCachedPersonDetails(int id) async {
    if (cacheBox == null) return null;
    return cacheBox!.get('person_details_$id') as PersonDetailsModel?;
  }

  Future<List<PersonImageModel>> getPersonImages(int id) async {
    final images = await tmdbApi.getPersonImages(id);
    final personImages = images.map((image) => PersonImageModel.fromJson(image)).toList();
    
    if (cacheBox != null) {
      await cacheBox!.put('person_images_$id', personImages);
    }
    
    return personImages;
  }

  Future<List<PersonImageModel>> getCachedPersonImages(int id) async {
    if (cacheBox == null) return [];
    final raw = cacheBox!.get('person_images_$id');
    if (raw == null) return [];
    return (raw as List).cast<PersonImageModel>();
  }
}
