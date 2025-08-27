part of 'search_cubit.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  const SearchLoaded(this.movies);
  final List<Movie> movies;

  @override
  List<Object> get props => [movies];
}

class SearchError extends SearchState {
  const SearchError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
