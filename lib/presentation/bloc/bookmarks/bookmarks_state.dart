part of 'bookmarks_cubit.dart';

abstract class BookmarksState extends Equatable {
  const BookmarksState();

  @override
  List<Object> get props => [];
}

class BookmarksInitial extends BookmarksState {}

class BookmarksLoading extends BookmarksState {}

class BookmarksLoaded extends BookmarksState {

  const BookmarksLoaded(this.movies);
  final List<Movie> movies;

  @override
  List<Object> get props => [movies];
}

class BookmarksError extends BookmarksState {

  const BookmarksError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
