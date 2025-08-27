// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:moviestash/core/di/register_module.dart' as _i590;
import 'package:moviestash/core/local_storage/hive_service.dart' as _i608;
import 'package:moviestash/core/local_storage/hive_service_impl.dart' as _i478;
import 'package:moviestash/core/network/http_client_service.dart' as _i673;
import 'package:moviestash/core/network/http_client_service_impl.dart' as _i943;
import 'package:moviestash/data/datasources/movie_api_service.dart' as _i319;
import 'package:moviestash/data/datasources/movie_local_data_source.dart'
    as _i419;
import 'package:moviestash/data/datasources/movie_local_data_source_impl.dart'
    as _i464;
import 'package:moviestash/data/repositories/movie_repository_impl.dart'
    as _i144;
import 'package:moviestash/domain/repositories/movie_repository.dart' as _i382;
import 'package:moviestash/domain/usecases/bookmark_usecases.dart' as _i138;
import 'package:moviestash/domain/usecases/get_movie_detail.dart' as _i338;
import 'package:moviestash/domain/usecases/get_now_playing_movies.dart'
    as _i797;
import 'package:moviestash/domain/usecases/get_trending_movies.dart' as _i350;
import 'package:moviestash/domain/usecases/listen_to_bookmark_changes.dart'
    as _i516;
import 'package:moviestash/domain/usecases/search_movies.dart' as _i135;
import 'package:moviestash/presentation/bloc/bookmarks/bookmarks_cubit.dart'
    as _i671;
import 'package:moviestash/presentation/bloc/home/home_cubit.dart' as _i535;
import 'package:moviestash/presentation/bloc/movie_detail/movie_detail_cubit.dart'
    as _i858;
import 'package:moviestash/presentation/bloc/search/search_cubit.dart' as _i833;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i608.HiveService>(() => _i478.HiveServiceImpl());
    gh.lazySingleton<_i673.HttpClientService>(
        () => _i943.HttpClientServiceImpl());
    gh.lazySingleton<_i419.MovieLocalDataSource>(
        () => _i464.MovieLocalDataSourceImpl(gh<_i608.HiveService>()));
    gh.lazySingleton<_i319.MovieApiService>(
        () => _i319.MovieApiService(gh<_i673.HttpClientService>()));
    gh.lazySingleton<_i382.MovieRepository>(() => _i144.MovieRepositoryImpl(
          apiService: gh<_i319.MovieApiService>(),
          localDataSource: gh<_i419.MovieLocalDataSource>(),
          connectivity: gh<_i895.Connectivity>(),
        ));
    gh.lazySingleton<_i350.GetTrendingMovies>(
        () => _i350.GetTrendingMovies(gh<_i382.MovieRepository>()));
    gh.lazySingleton<_i797.GetNowPlayingMovies>(
        () => _i797.GetNowPlayingMovies(gh<_i382.MovieRepository>()));
    gh.lazySingleton<_i338.GetMovieDetail>(
        () => _i338.GetMovieDetail(gh<_i382.MovieRepository>()));
    gh.lazySingleton<_i516.ListenToBookmarkChanges>(
        () => _i516.ListenToBookmarkChanges(gh<_i382.MovieRepository>()));
    gh.lazySingleton<_i138.BookmarkMovie>(
        () => _i138.BookmarkMovie(gh<_i382.MovieRepository>()));
    gh.lazySingleton<_i138.RemoveBookmark>(
        () => _i138.RemoveBookmark(gh<_i382.MovieRepository>()));
    gh.lazySingleton<_i138.GetBookmarkedMovies>(
        () => _i138.GetBookmarkedMovies(gh<_i382.MovieRepository>()));
    gh.lazySingleton<_i135.SearchMovies>(
        () => _i135.SearchMovies(gh<_i382.MovieRepository>()));
    gh.factory<_i833.SearchCubit>(() => _i833.SearchCubit(
          searchMovies: gh<_i135.SearchMovies>(),
          listenToBookmarkChanges: gh<_i516.ListenToBookmarkChanges>(),
          getBookmarkedMovies: gh<_i138.GetBookmarkedMovies>(),
        ));
    gh.factory<_i671.BookmarksCubit>(() => _i671.BookmarksCubit(
          getBookmarkedMovies: gh<_i138.GetBookmarkedMovies>(),
          removeBookmark: gh<_i138.RemoveBookmark>(),
          listenToBookmarkChanges: gh<_i516.ListenToBookmarkChanges>(),
        ));
    gh.factory<_i858.MovieDetailCubit>(() => _i858.MovieDetailCubit(
          getMovieDetail: gh<_i338.GetMovieDetail>(),
          bookmarkMovie: gh<_i138.BookmarkMovie>(),
          removeBookmark: gh<_i138.RemoveBookmark>(),
          listenToBookmarkChanges: gh<_i516.ListenToBookmarkChanges>(),
        ));
    gh.factory<_i535.HomeCubit>(() => _i535.HomeCubit(
          getTrendingMovies: gh<_i350.GetTrendingMovies>(),
          getNowPlayingMovies: gh<_i797.GetNowPlayingMovies>(),
          listenToBookmarkChanges: gh<_i516.ListenToBookmarkChanges>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i590.RegisterModule {}
