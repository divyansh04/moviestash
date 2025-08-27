part of 'movie_detail_cubit.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailLoaded extends MovieDetailState {

  const MovieDetailLoaded(this.movieDetail);
  final MovieDetail movieDetail;

   MovieDetailLoaded copyWith({MovieDetail? movieDetail}) {
    return MovieDetailLoaded(movieDetail ?? this.movieDetail);
  }

  @override
  List<Object> get props => [movieDetail];
}

class MovieDetailError extends MovieDetailState {

  const MovieDetailError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
