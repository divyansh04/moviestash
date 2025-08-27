import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:moviestash/core/usecases/usecase.dart';
import 'package:moviestash/core/utils/result.dart';
import 'package:moviestash/domain/entities/movie.dart';
import 'package:moviestash/domain/usecases/bookmark_usecases.dart';
import 'package:moviestash/domain/usecases/listen_to_bookmark_changes.dart';


part 'bookmarks_state.dart';

@injectable
class BookmarksCubit extends Cubit<BookmarksState> {

  BookmarksCubit({
    required this.getBookmarkedMovies,
    required this.removeBookmark,
    required this.listenToBookmarkChanges,
  }) : super(BookmarksInitial()) {
    loadBookmarkedMovies();
    _listenToBookmarks(); // Listen for changes from the beginning
  }
  final GetBookmarkedMovies getBookmarkedMovies;
  final RemoveBookmark removeBookmark;

  final ListenToBookmarkChanges listenToBookmarkChanges;

  late StreamSubscription<int> _bookmarkSubscription;

  Future<void> loadBookmarkedMovies() async {
    emit(BookmarksLoading());

    final result = await getBookmarkedMovies(const NoParams());

    if (result.isSuccess) {
      emit(BookmarksLoaded(result.data!));
    } else {
      emit(BookmarksError(result.exception!.message));
    }
  }

  Future<void> removeBookmarkById(int movieId) async {
    await removeBookmark(RemoveBookmarkParams(movieId: movieId));
    await loadBookmarkedMovies();
  }

  void _listenToBookmarks() {
    _bookmarkSubscription = listenToBookmarkChanges.listen().listen((movieId) {
      // When a bookmark change is detected, re-fetch the entire list.
      // This is the most reliable way to ensure the bookmarked list is up-to-date.
      loadBookmarkedMovies();
    });
  }

  @override
  Future<void> close() {
    _bookmarkSubscription.cancel();
    return super.close();
  }
}
