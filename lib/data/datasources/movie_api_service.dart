import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:moviestash/core/constants/api_constants.dart';
import 'package:moviestash/core/network/http_client_service.dart';
import 'package:moviestash/data/models/movie_detail_model.dart';
import 'package:moviestash/data/models/movie_model.dart';
import 'package:retrofit/retrofit.dart';

part 'movie_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
@lazySingleton
abstract class MovieApiService {
  @factoryMethod
  factory MovieApiService(HttpClientService httpClientService) =>
      _MovieApiService(httpClientService.dio);

  @GET(ApiConstants.trending)
  Future<MoviesResponse> getTrendingMovies(@Query('page') int page);

  @GET(ApiConstants.nowPlaying)
  Future<MoviesResponse> getNowPlayingMovies(@Query('page') int page);

  @GET(ApiConstants.movieDetails)
  Future<MovieDetailModel> getMovieDetail(@Path('id') int movieId);

  @GET(ApiConstants.search)
  Future<MoviesResponse> searchMovies(@Query('query') String query);
}
