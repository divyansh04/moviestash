import 'package:injectable/injectable.dart';
import '../../core/usecases/usecase.dart';
import '../../core/utils/result.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

@lazySingleton
class GetNowPlayingMovies implements UseCase<List<Movie>, PaginationParams> {

  GetNowPlayingMovies(this.repository);
  final MovieRepository repository;

  @override
  Future<Result<List<Movie>>> call(PaginationParams params) async {
    return repository.getNowPlayingMovies(params.page);
  }
}
