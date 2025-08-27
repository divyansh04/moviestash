import 'package:injectable/injectable.dart';
import 'package:moviestash/core/usecases/usecase.dart';
import 'package:moviestash/core/utils/result.dart';
import 'package:moviestash/domain/entities/movie.dart';
import 'package:moviestash/domain/repositories/movie_repository.dart';

@lazySingleton
class GetTrendingMovies implements UseCase<List<Movie>, PaginationParams> {

  GetTrendingMovies(this.repository);
  final MovieRepository repository;

  @override
  Future<Result<List<Movie>>> call(PaginationParams params) async {
    return repository.getTrendingMovies(params.page);
  }
}
