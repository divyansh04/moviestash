import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:moviestash/core/usecases/usecase.dart';
import 'package:moviestash/core/utils/result.dart';
import 'package:moviestash/domain/entities/movie.dart';
import 'package:moviestash/domain/repositories/movie_repository.dart';

@lazySingleton
class SearchMovies implements UseCase<List<Movie>, SearchMoviesParams> {

  SearchMovies(this.repository);
  final MovieRepository repository;

  @override
  Future<Result<List<Movie>>> call(SearchMoviesParams params) async {
    return repository.searchMovies(params.query);
  }
}

class SearchMoviesParams extends Equatable {

  const SearchMoviesParams({required this.query});
  final String query;

  @override
  List<Object> get props => [query];
}
