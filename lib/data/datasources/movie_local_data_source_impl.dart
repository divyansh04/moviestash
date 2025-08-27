import 'package:injectable/injectable.dart';
import 'package:moviestash/data/datasources/movie_local_data_source.dart';
import 'package:moviestash/data/models/movie_detail_model.dart';
import '../../core/local_storage/hive_service.dart';
import '../models/movie_model.dart';

@LazySingleton(as: MovieLocalDataSource)
class MovieLocalDataSourceImpl implements MovieLocalDataSource {

  MovieLocalDataSourceImpl(this._hiveService);
  final HiveService _hiveService;

  @override
  Future<void> cacheTrendingMovies(List<MovieModel> movies) async {
    final box = await _hiveService.openTrendingMoviesBox();

    final movieMap = <int, MovieModel>{
      for (final movie in movies) movie.id: movie,
    };

    await box.putAll(movieMap);
  }

  @override
  Future<List<MovieModel>> getTrendingMovies() async {
    final box = await _hiveService.openTrendingMoviesBox();
    return box.values.toList();
  }

  @override
  Future<void> cacheNowPlayingMovies(List<MovieModel> movies) async {
    final box = await _hiveService.openNowPlayingMoviesBox();

    final movieMap = <int, MovieModel>{
      for (final movie in movies) movie.id: movie,
    };

    await box.putAll(movieMap);
  }

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    final box = await _hiveService.openNowPlayingMoviesBox();
    return box.values.toList();
  }

  @override
  Future<void> cacheMovieDetail(int movieId, MovieDetailModel model) async {
    final box = await _hiveService.openMovieDetailsBox();
    await box.put(movieId, model);
  }

  @override
  Future<MovieDetailModel?> getCachedMovieDetail(int movieId) async {
    final box = await _hiveService.openMovieDetailsBox();
    return box.get(movieId);
  }

  @override
  Future<void> bookmarkMovie(MovieModel movie) async {
    final bookmarkedBox = await _hiveService.openBookmarkedMoviesBox();
    await bookmarkedBox.put(movie.id, movie.copyWith(isBookmarked: true));

    await _updateMovieInAllBoxes(
      movie.id,
      (existingMovie) => existingMovie.copyWith(isBookmarked: true),
    );
    await _setMovieDetailBookmarked(movie.id, true);
  }

  @override
  Future<void> removeBookmark(int movieId) async {
    final bookmarkedBox = await _hiveService.openBookmarkedMoviesBox();
    await bookmarkedBox.delete(movieId);

    await _updateMovieInAllBoxes(
      movieId,
      (existingMovie) => existingMovie.copyWith(isBookmarked: false),
    );
    await _setMovieDetailBookmarked(movieId, false);
  }

  Future<void> _updateMovieInAllBoxes(
    int movieId,
    MovieModel Function(MovieModel) updateFunction,
  ) async {
    final trendingBox = await _hiveService.openTrendingMoviesBox();
    final nowPlayingBox = await _hiveService.openNowPlayingMoviesBox();

    final boxes = [trendingBox, nowPlayingBox];

    for (final box in boxes) {
      if (box.containsKey(movieId)) {
        final existingMovie = box.get(movieId);
        if (existingMovie != null) {
          await box.put(movieId, updateFunction(existingMovie));
        }
      }
    }
  }

  Future<void> _setMovieDetailBookmarked(int movieId, bool isBookmarked) async {
    final box = await _hiveService.openMovieDetailsBox();
    final existing = box.get(movieId);
    if (existing != null) {
      await box.put(movieId, existing.copyWith(isBookmarked: isBookmarked));
    }
  }

  @override
  Future<List<MovieModel>> getBookmarkedMovies() async {
    final box = await _hiveService.openBookmarkedMoviesBox();
    return box.values.toList();
  }

  @override
  Future<bool> isMovieBookmarked(int movieId) async {
    final box = await _hiveService.openBookmarkedMoviesBox();
    return box.containsKey(movieId);
  }

  @override
  Future<void> clearCache() async {
    await _hiveService.clearAllData();
  }
}
