import 'package:injectable/injectable.dart';
import '../../core/usecases/usecase.dart';
import '../../core/utils/result.dart';
import '../entities/movie_detail.dart';
import '../repositories/movie_repository.dart';

@lazySingleton
class GetMovieDetail implements UseCase<MovieDetail, int> {

  GetMovieDetail(this.repository);
  final MovieRepository repository;

  @override
  Future<Result<MovieDetail>> call(int movieId) async {
    return repository.getMovieDetail(movieId);
  }
}
