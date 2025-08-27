import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static final String apiKey = dotenv.env['TMDB_API_KEY']!;
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  // Endpoints
  static const String trending = '/trending/movie/day';
  static const String movieDetails = '/movie/{id}';
  static const String nowPlaying = '/movie/now_playing';
  static const String search = '/search/movie';
}
