import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:moviestash/core/error/exceptions.dart';
import 'package:moviestash/core/utils/result.dart';
import 'package:moviestash/data/datasources/movie_api_service.dart';
import 'package:moviestash/data/datasources/movie_local_data_source.dart';
import 'package:moviestash/data/models/movie_detail_model.dart';
import 'package:moviestash/data/models/movie_model.dart';
import 'package:moviestash/domain/entities/movie.dart';
import 'package:moviestash/domain/entities/movie_detail.dart';
import 'package:moviestash/domain/repositories/movie_repository.dart';

@LazySingleton(as: MovieRepository)
class MovieRepositoryImpl implements MovieRepository {

  MovieRepositoryImpl({
    required this.apiService,
    required this.localDataSource,
    required this.connectivity,
  });
  final MovieApiService apiService;
  final MovieLocalDataSource localDataSource;
  final Connectivity connectivity;

  @override
  Future<Result<List<Movie>>> getTrendingMovies(int page) async {
    return _getMoviesWithCache(
      () => apiService.getTrendingMovies(page),
      localDataSource.getTrendingMovies,
      localDataSource.cacheTrendingMovies,
    );
  }

  @override
  Future<Result<List<Movie>>> getNowPlayingMovies(int page) async {
    return _getMoviesWithCache(
      () => apiService.getNowPlayingMovies(page),
      localDataSource.getNowPlayingMovies,
      localDataSource.cacheNowPlayingMovies,
    );
  }

  Future<Result<List<Movie>>> _getMoviesWithCache(
    Future<MoviesResponse> Function() apiCall,
    Future<List<MovieModel>> Function() cacheCall,
    Future<void> Function(List<MovieModel>) cacheUpdate,
  ) async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        // OFFLINE: read cache, then overlay bookmark flags before returning
        final cachedMovies = await cacheCall();
        final movies = await _overlayAndMap(cachedMovies);
        return Success(movies);
      }

      try {
        // ONLINE: fetch, overlay, cache merged, return
        final response = await apiCall();
        final fetched = response.results;

        final merged = <MovieModel>[];
        for (final movie in fetched) {
          final isB = await localDataSource.isMovieBookmarked(movie.id);
          merged.add(movie.copyWith(isBookmarked: isB));
        }

        await cacheUpdate(merged);

        // Return mapped with overlay (safe even though merged already has it)
        final movies = await _overlayAndMap(merged);
        return Success(movies);
      } catch (e) {
        // ONLINE FAILED: fallback to cache, overlay before return
        final cachedMovies = await cacheCall();
        if (cachedMovies.isNotEmpty) {
          final movies = await _overlayAndMap(cachedMovies);
          return Success(movies);
        }
        return Failure(ServerException('Failed to load movies: $e'));
      }
    } catch (e) {
      return Failure(CacheException('Cache error: $e'));
    }
  }

  // Helper function to overlay bookmark status and map to domain entities
  Future<List<Movie>> _overlayAndMap(List<MovieModel> movies) async {
    final updatedMovies = <Movie>[];
    for (final movieModel in movies) {
      final isBookmarked = await localDataSource.isMovieBookmarked(
        movieModel.id,
      );
      updatedMovies.add(
        movieModel.copyWith(isBookmarked: isBookmarked).toDomain(),
      );
    }
    return updatedMovies;
  }

  @override
  Future<Result<MovieDetail>> getMovieDetail(int movieId) async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        final cached = await localDataSource.getCachedMovieDetail(movieId);
        if (cached != null) {
          return Success(await _toDomainWithBookmark(cached));
        }
        return Failure(CacheException('No cached details for movie $movieId'));
      }

      try {
        final remote = await apiService.getMovieDetail(movieId);
        final bookmarked = await localDataSource.isMovieBookmarked(movieId);
        final merged = remote.copyWith(isBookmarked: bookmarked);
        await localDataSource.cacheMovieDetail(movieId, merged);
        return Success(await _toDomainWithBookmark(merged));
      } catch (e) {
        final cached = await localDataSource.getCachedMovieDetail(movieId);
        if (cached != null) {
          return Success(await _toDomainWithBookmark(cached));
        }
        return Failure(ServerException('Failed to load detail: $e'));
      }
    } catch (e) {
      return Failure(CacheException('Detail cache error: $e'));
    }
  }

  Future<MovieDetail> _toDomainWithBookmark(MovieDetailModel m) async {
    final bookmarked = await localDataSource.isMovieBookmarked(m.id);
    final merged = m.copyWith(isBookmarked: bookmarked);
    return merged.toDomain();
  }

  @override
  Future<Result<List<Movie>>> searchMovies(String query) async {
    try {
      final response = await apiService.searchMovies(query);

      final updatedMovies = <MovieModel>[];
      for (final movie in response.results) {
        final isBookmarked = await localDataSource.isMovieBookmarked(movie.id);
        updatedMovies.add(movie.copyWith(isBookmarked: isBookmarked));
      }

      return Success(updatedMovies.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Failure(ServerException('Failed to search movies: $e'));
    }
  }

  final _bookmarkStatusController = StreamController<int>.broadcast();

  // Expose the stream for other Cubits to listen to
  @override
  Stream<int> get bookmarkStatusStream => _bookmarkStatusController.stream;

  @override
  Future<Result<void>> bookmarkMovie(Movie movie) async {
    try {
      await localDataSource.bookmarkMovie(MovieModel.fromDomain(movie));
      _bookmarkStatusController.sink.add(movie.id); // Notify listeners
      return const Success(null);
    } catch (e) {
      return Failure(CacheException('Failed to bookmark movie: $e'));
    }
  }

  @override
  Future<Result<void>> removeBookmark(int movieId) async {
    try {
      await localDataSource.removeBookmark(movieId);
      _bookmarkStatusController.sink.add(movieId); // Notify listeners
      return const Success(null);
    } catch (e) {
      return Failure(CacheException('Failed to remove bookmark: $e'));
    }
  }

  void dispose() {
    _bookmarkStatusController.close();
  }

  @override
  Future<Result<List<Movie>>> getBookmarkedMovies() async {
    try {
      final movies = await localDataSource.getBookmarkedMovies();
      return Success(movies.map((model) => model.toDomain()).toList().toList());
    } catch (e) {
      return Failure(CacheException('Failed to get bookmarked movies: $e'));
    }
  }

  @override
  Future<Result<bool>> isMovieBookmarked(int movieId) async {
    try {
      final isBookmarked = await localDataSource.isMovieBookmarked(movieId);
      return Success(isBookmarked);
    } catch (e) {
      return Failure(CacheException('Failed to check bookmark: $e'));
    }
  }
}
