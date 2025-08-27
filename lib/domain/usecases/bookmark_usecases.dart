import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:moviestash/core/usecases/usecase.dart';
import 'package:moviestash/core/utils/result.dart';
import 'package:moviestash/domain/entities/movie.dart';
import 'package:moviestash/domain/repositories/movie_repository.dart';

@lazySingleton
class BookmarkMovie implements UseCase<void, BookmarkMovieParams> {

  BookmarkMovie(this.repository);
  final MovieRepository repository;

  @override
  Future<Result<void>> call(BookmarkMovieParams params) async {
    return repository.bookmarkMovie(params.movie);
  }
}

@lazySingleton
class RemoveBookmark implements UseCase<void, RemoveBookmarkParams> {

  RemoveBookmark(this.repository);
  final MovieRepository repository;

  @override
  Future<Result<void>> call(RemoveBookmarkParams params) async {
    return repository.removeBookmark(params.movieId);
  }
}

@lazySingleton
class GetBookmarkedMovies implements UseCase<List<Movie>, NoParams> {

  GetBookmarkedMovies(this.repository);
  final MovieRepository repository;

  @override
  Future<Result<List<Movie>>> call(NoParams params) async {
    return repository.getBookmarkedMovies();
  }
}

class BookmarkMovieParams extends Equatable {

  const BookmarkMovieParams({required this.movie});
  final Movie movie;

  @override
  List<Object> get props => [movie];
}

class RemoveBookmarkParams extends Equatable {

  const RemoveBookmarkParams({required this.movieId});
  final int movieId;

  @override
  List<Object> get props => [movieId];
}
