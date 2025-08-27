import 'package:moviestash/core/utils/result.dart';
import 'package:moviestash/domain/entities/movie.dart';
import 'package:moviestash/domain/entities/movie_detail.dart';


abstract class MovieRepository {
  Future<Result<List<Movie>>> getTrendingMovies(int page);
  Future<Result<List<Movie>>> getNowPlayingMovies(int page);
  Future<Result<MovieDetail>> getMovieDetail(int movieId);
  Future<Result<List<Movie>>> searchMovies(String query);
  Future<Result<void>> bookmarkMovie(Movie movie);
  Future<Result<void>> removeBookmark(int movieId);
  Future<Result<List<Movie>>> getBookmarkedMovies();
  Future<Result<bool>> isMovieBookmarked(int movieId);
  Stream<int> get bookmarkStatusStream;
}
