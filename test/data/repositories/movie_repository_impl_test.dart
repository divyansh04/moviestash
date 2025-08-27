import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moviestash/core/error/exceptions.dart';
import 'package:moviestash/core/utils/result.dart';
import 'package:moviestash/data/datasources/movie_api_service.dart';
import 'package:moviestash/data/datasources/movie_local_data_source.dart';
import 'package:moviestash/data/models/movie_model.dart';
import 'package:moviestash/data/repositories/movie_repository_impl.dart';

// Mocks
class _MockApiService extends Mock implements MovieApiService {}

class _MockLocalDataSource extends Mock implements MovieLocalDataSource {}

class _MockConnectivity extends Mock implements Connectivity {}

// Helpers
MovieModel _movieModel({int id = 1, bool isBookmarked = false}) => MovieModel(
  id: id,
  title: 'Title $id',
  overview: 'Overview $id',
  posterPath: '/poster$id.jpg',
  backdropPath: '/backdrop$id.jpg',
  voteAverage: 8.1,
  releaseDate: '2024-01-0$id',
  genreIds: const [1, 2],
  isBookmarked: isBookmarked,
);

MoviesResponse _moviesResponse(List<MovieModel> list) => MoviesResponse(
  page: 1,
  results: list,
  totalPages: 1,
  totalResults: list.length,
);

void main() {
  late _MockApiService api;
  late _MockLocalDataSource local;
  late _MockConnectivity conn;
  late MovieRepositoryImpl repo;

  setUp(() {
    api = _MockApiService();
    local = _MockLocalDataSource();
    conn = _MockConnectivity();
    repo = MovieRepositoryImpl(
      apiService: api,
      localDataSource: local,
      connectivity: conn,
    );
  });

  group('getTrendingMovies', () {
    const page = 1;

    test('offline: returns cached movies with bookmark overlay', () async {
      when(
        () => conn.checkConnectivity(),
      ).thenAnswer((_) async => ConnectivityResult.none);

      final cached = [_movieModel(), _movieModel(id: 2)];
      when(() => local.getTrendingMovies()).thenAnswer((_) async => cached);
      when(() => local.isMovieBookmarked(1)).thenAnswer((_) async => true);
      when(() => local.isMovieBookmarked(2)).thenAnswer((_) async => false);

      final res = await repo.getTrendingMovies(page);
      expect(res.isSuccess, true);
      final data = res.data!;
      expect(data.length, 2);
      expect(data[0].isBookmarked, true);
      expect(data[1].isBookmarked, false);

      verify(() => local.getTrendingMovies()).called(1);
      verify(() => local.isMovieBookmarked(1)).called(1);
      verify(() => local.isMovieBookmarked(2)).called(1);
      verifyNever(() => api.getTrendingMovies(any()));
    });

    test('online: fetch, overlay, cache, return', () async {
      when(
        () => conn.checkConnectivity(),
      ).thenAnswer((_) async => ConnectivityResult.wifi);

      final fetched = [_movieModel(), _movieModel(id: 2)];
      when(
        () => api.getTrendingMovies(page),
      ).thenAnswer((_) async => _moviesResponse(fetched));

      when(() => local.isMovieBookmarked(1)).thenAnswer((_) async => true);
      when(() => local.isMovieBookmarked(2)).thenAnswer((_) async => false);

      when(
        () => local.cacheTrendingMovies(any()),
      ).thenAnswer((_) async => Future.value());

      final res = await repo.getTrendingMovies(page);
      expect(res.isSuccess, true);
      final data = res.data!;
      expect(data[0].id, 1);
      expect(data[0].isBookmarked, true);
      expect(data[1].isBookmarked, false);

      verify(() => api.getTrendingMovies(page)).called(1);
      verify(() => local.cacheTrendingMovies(any())).called(1);
    });

    test(
      'outer catch: returns CacheException Failure on unexpected error',
      () async {
        when(() => conn.checkConnectivity()).thenThrow(Exception('boom'));

        final res = await repo.getTrendingMovies(page);
        expect(res.isFailure, true);
        expect(res.exception, isA<CacheException>());
      },
    );
  });
}
