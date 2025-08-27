import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:moviestash/core/utils/result.dart';
import 'package:moviestash/domain/entities/movie.dart';
import 'package:moviestash/domain/entities/movie_detail.dart';
import 'package:moviestash/domain/usecases/bookmark_usecases.dart';
import 'package:moviestash/domain/usecases/get_movie_detail.dart';
import 'package:moviestash/domain/usecases/listen_to_bookmark_changes.dart';

part 'movie_detail_state.dart';

@injectable
class MovieDetailCubit extends Cubit<MovieDetailState> {
  MovieDetailCubit({
    required this.getMovieDetail,
    required this.bookmarkMovie,
    required this.removeBookmark,
    required this.listenToBookmarkChanges,
  }) : super(MovieDetailInitial()) {
    _listenToBookmarks();
  }
  final GetMovieDetail getMovieDetail;
  final BookmarkMovie bookmarkMovie;
  final RemoveBookmark removeBookmark;
  final ListenToBookmarkChanges listenToBookmarkChanges;

  late StreamSubscription<int> _bookmarkSubscription;

  Future<void> load(int movieId) async {
    emit(MovieDetailLoading());

    final result = await getMovieDetail(movieId);

    if (result.isSuccess) {
      emit(MovieDetailLoaded(result.data!));
    } else {
      emit(MovieDetailError(result.exception!.message));
    }
  }

  Future<void> toggleBookmark() async {
    if (state is MovieDetailLoaded) {
      final currentState = state as MovieDetailLoaded;
      final movieDetail = currentState.movieDetail;

      if (movieDetail.isBookmarked) {
        await removeBookmark(RemoveBookmarkParams(movieId: movieDetail.id));
      } else {
        final movie = Movie(
          id: movieDetail.id,
          title: movieDetail.title,
          overview: movieDetail.overview,
          posterPath: movieDetail.posterPath,
          backdropPath: movieDetail.backdropPath,
          voteAverage: movieDetail.voteAverage,
          releaseDate: movieDetail.releaseDate,
          genreIds: movieDetail.genres.map((g) => g.id).toList(),
        );
        await bookmarkMovie(BookmarkMovieParams(movie: movie));
      }
      emit(
        MovieDetailLoaded(
          currentState.movieDetail.copyWith(
            isBookmarked: currentState.movieDetail.isBookmarked,
          ),
        ),
      );
    }

    return;
  }

  // This method listens to changes from the repository and updates the UI.
  void _listenToBookmarks() {
    _bookmarkSubscription = listenToBookmarkChanges.listen().listen((movieId) {
      if (state is MovieDetailLoaded) {
        final currentState = state as MovieDetailLoaded;
        if (currentState.movieDetail.id == movieId) {
          emit(
            MovieDetailLoaded(
              currentState.movieDetail.copyWith(
                isBookmarked: !currentState.movieDetail.isBookmarked,
              ),
            ),
          );
        }
      }
    });
  }

  @override
  Future<void> close() {
    _bookmarkSubscription.cancel();
    return super.close();
  }
}
