import 'package:tmdb/configs/api_config.dart';

import '../../core/api_client.dart';
import '../models/person_model.dart';

class TmdbApi {
  final ApiClient client;

  TmdbApi({ApiClient? client})
    : client =
          client ??
          ApiClient(
            baseUrl: 'https://api.themoviedb.org/3',
            apiKey: ApiConfig.apiKey ?? "",
          );

  Future<List<PersonModel>> getPopularPeople({int page = 1}) async {
    final res = await client.get(
      '/person/popular',
      params: {'page': page.toString()},
    );
    final results = (res['results'] as List).cast<Map<String, dynamic>>();
    return results.map((e) => PersonModel.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> getPersonDetails(int id) async {
    final res = await client.get('/person/$id');
    return res;
  }

  Future<List<Map<String, dynamic>>> getPersonImages(int id) async {
    final res = await client.get('/person/$id/images');
    final profiles = (res['profiles'] as List).cast<Map<String, dynamic>>();
    return profiles;
  }
}
