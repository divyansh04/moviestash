import 'package:moviestash/data/models/movie_detail_model.dart';
import 'package:moviestash/data/models/movie_model.dart';


abstract class MovieLocalDataSource {
  Future<void> cacheTrendingMovies(List<MovieModel> movies);
  Future<List<MovieModel>> getTrendingMovies();
  Future<void> cacheNowPlayingMovies(List<MovieModel> movies);
  Future<List<MovieModel>> getNowPlayingMovies();
    Future<void> cacheMovieDetail(int movieId, MovieDetailModel model);
  Future<MovieDetailModel?> getCachedMovieDetail(int movieId);
  Future<void> bookmarkMovie(MovieModel movie);
  Future<void> removeBookmark(int movieId);
  Future<List<MovieModel>> getBookmarkedMovies();
  Future<bool> isMovieBookmarked(int movieId);
  Future<void> clearCache();
}
