import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:moviestash/core/usecases/usecase.dart';
import 'package:moviestash/core/utils/result.dart';
import 'package:moviestash/domain/entities/movie.dart';
import 'package:moviestash/domain/usecases/bookmark_usecases.dart';
import 'package:moviestash/domain/usecases/listen_to_bookmark_changes.dart';
import 'package:moviestash/domain/usecases/search_movies.dart';

part 'search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required this.searchMovies,
    required this.listenToBookmarkChanges,
    required this.getBookmarkedMovies,
  }) : super(SearchInitial()) {
    _listenToBookmarks();
  }
  final SearchMovies searchMovies;
  final ListenToBookmarkChanges listenToBookmarkChanges;
  final GetBookmarkedMovies getBookmarkedMovies; // Add use case as a field

  late StreamSubscription<int> _bookmarkSubscription;
  Timer? _debounceTimer;

  void onQueryChanged(String query) {
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      submit(query);
    });
  }

  Future<void> submit(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    final result = await searchMovies(SearchMoviesParams(query: query));

    if (result.isSuccess) {
      final movies = result.data!;
      final updatedMovies = await _overlayBookmarkStatus(movies);
      emit(SearchLoaded(updatedMovies));
    } else {
      emit(SearchError(result.exception!.message));
    }
  }

  void _listenToBookmarks() {
    _bookmarkSubscription = listenToBookmarkChanges.listen().listen((movieId) {
      if (state is SearchLoaded) {
        final currentState = state as SearchLoaded;
        final updatedMovies =
            currentState.movies.map((movie) {
              if (movie.id == movieId) {
                return movie.copyWith(isBookmarked: !movie.isBookmarked);
              }
              return movie;
            }).toList();
        emit(SearchLoaded(updatedMovies));
      }
    });
  }

  Future<List<Movie>> _overlayBookmarkStatus(List<Movie> movies) async {
    final bookmarkedResult = await getBookmarkedMovies(const NoParams());
    if (bookmarkedResult.isSuccess) {
      final bookmarkedIds = bookmarkedResult.data!.map((m) => m.id).toSet();
      return movies.map((movie) {
        return movie.copyWith(isBookmarked: bookmarkedIds.contains(movie.id));
      }).toList();
    }
    return movies;
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    _bookmarkSubscription.cancel();
    return super.close();
  }
}
