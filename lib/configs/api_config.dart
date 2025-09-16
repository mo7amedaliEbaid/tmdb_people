import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  final envKey = dotenv.maybeGet('TMDB_API_KEY');
  static final String? apiKey = dotenv.maybeGet('TMDB_API_KEY');
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/original';
}
