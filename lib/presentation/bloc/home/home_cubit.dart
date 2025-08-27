import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:moviestash/core/usecases/usecase.dart';
import 'package:moviestash/core/utils/result.dart';
import 'package:moviestash/domain/entities/movie.dart';
import 'package:moviestash/domain/usecases/get_now_playing_movies.dart';
import 'package:moviestash/domain/usecases/get_trending_movies.dart';
import 'package:moviestash/domain/usecases/listen_to_bookmark_changes.dart';

part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required this.getTrendingMovies,
    required this.getNowPlayingMovies,
    required this.listenToBookmarkChanges,
  }) : super(HomeInitial()) {
    loadMovies();
    _listenToBookmarks();
  }
  final GetTrendingMovies getTrendingMovies;
  final GetNowPlayingMovies getNowPlayingMovies;
  final ListenToBookmarkChanges listenToBookmarkChanges;

  late StreamSubscription<int> _bookmarkSubscription;

  // Pagination state
  int _trendingPage = 1;
  int _nowPlayingPage = 1;
  bool _trendingHasMore = true;
  bool _nowPlayingHasMore = true;
  bool _isLoadingMoreTrending = false;
  bool _isLoadingMoreNowPlaying = false;

  //listen for bookmark changes
  void _listenToBookmarks() {
    _bookmarkSubscription = listenToBookmarkChanges.listen().listen((movieId) {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;

        List<Movie> updateList(List<Movie> movies) {
          return movies.map((m) {
            if (m.id == movieId) {
              return m.copyWith(isBookmarked: !m.isBookmarked);
            }
            return m;
          }).toList();
        }

        emit(
          currentState.copyWith(
            trendingMovies: updateList(currentState.trendingMovies),
            nowPlayingMovies: updateList(currentState.nowPlayingMovies),
          ),
        );
      }
    });
  }

  Future<void> loadMovies() async {
    emit(HomeLoading());

    _trendingPage = 1;
    _nowPlayingPage = 1;
    _trendingHasMore = true;
    _nowPlayingHasMore = true;

    final trendingResult = await getTrendingMovies(
      PaginationParams(page: _trendingPage),
    );
    final nowPlayingResult = await getNowPlayingMovies(
      PaginationParams(page: _nowPlayingPage),
    );

    if (trendingResult.isSuccess && nowPlayingResult.isSuccess) {
      emit(
        HomeLoaded(
          trendingMovies: trendingResult.data!,
          nowPlayingMovies: nowPlayingResult.data!,
          trendingHasMore: _trendingHasMore,
          nowPlayingHasMore: _nowPlayingHasMore,
        ),
      );
    } else {
      final errorMessage =
          trendingResult.exception?.message ??
          nowPlayingResult.exception?.message ??
          'Failed to load movies';
      emit(HomeError(errorMessage));
    }
  }

  Future<void> loadNextTrendingPage() async {
    if (!_trendingHasMore || _isLoadingMoreTrending) return;

    _isLoadingMoreTrending = true;
    final currentState = state as HomeLoaded;
    emit(currentState.copyWith(isLoadingMoreTrending: true));

    _trendingPage++;
    final result = await getTrendingMovies(
      PaginationParams(page: _trendingPage),
    );

    if (result.isSuccess) {
      final newMovies = result.data!;
      _trendingHasMore = newMovies.isNotEmpty;
      emit(
        currentState.copyWith(
          trendingMovies: [...currentState.trendingMovies, ...newMovies],
          isLoadingMoreTrending: false,
          trendingHasMore: _trendingHasMore,
        ),
      );
    } else {
      // Handle error case, maybe show a snackbar or just stop loading
      _trendingPage--;
      _isLoadingMoreTrending = false;
      emit(currentState.copyWith(isLoadingMoreTrending: false));
    }
  }

  Future<void> loadNextNowPlayingPage() async {
    if (!_nowPlayingHasMore || _isLoadingMoreNowPlaying) return;

    _isLoadingMoreNowPlaying = true;
    final currentState = state as HomeLoaded;
    emit(currentState.copyWith(isLoadingMoreNowPlaying: true));

    _nowPlayingPage++;
    final result = await getNowPlayingMovies(
      PaginationParams(page: _nowPlayingPage),
    );

    if (result.isSuccess) {
      final newMovies = result.data!;
      _nowPlayingHasMore = newMovies.isNotEmpty;
      emit(
        currentState.copyWith(
          nowPlayingMovies: [...currentState.nowPlayingMovies, ...newMovies],
          isLoadingMoreNowPlaying: false,
          nowPlayingHasMore: _nowPlayingHasMore,
        ),
      );
    } else {
      // Handle error case
      _nowPlayingPage--;
      _isLoadingMoreNowPlaying = false;
      emit(currentState.copyWith(isLoadingMoreNowPlaying: false));
    }
  }

  Future<void> refreshMovies() async {
    // Keep current content visible while refreshing
    if (state is HomeLoaded) {
      final s = state as HomeLoaded;
      emit(s.copyWith(isRefreshing: true));
    }

    _trendingPage = 1;
    _nowPlayingPage = 1;
    _trendingHasMore = true;
    _nowPlayingHasMore = true;

    final trendingResult = await getTrendingMovies(
      PaginationParams(page: _trendingPage),
    );
    final nowPlayingResult = await getNowPlayingMovies(
      PaginationParams(page: _nowPlayingPage),
    );

    if (trendingResult.isSuccess && nowPlayingResult.isSuccess) {
      emit(
        HomeLoaded(
          trendingMovies: trendingResult.data!,
          nowPlayingMovies: nowPlayingResult.data!,
          trendingHasMore: _trendingHasMore,
          nowPlayingHasMore: _nowPlayingHasMore,
        ),
      );
    } else {
      final errorMessage =
          trendingResult.exception?.message ??
          nowPlayingResult.exception?.message ??
          'Failed to refresh movies';
      emit(HomeError(errorMessage));
    }
  }

  @override
  Future<void> close() {
    _bookmarkSubscription.cancel();
    return super.close();
  }
}
