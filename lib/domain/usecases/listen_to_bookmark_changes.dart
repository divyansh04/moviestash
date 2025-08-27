import 'package:injectable/injectable.dart';
import 'package:moviestash/core/usecases/usecase.dart';
import 'package:moviestash/core/utils/result.dart';
import 'package:moviestash/domain/repositories/movie_repository.dart';

@lazySingleton
class ListenToBookmarkChanges implements UseCase<Stream<int>, NoParams> {
  ListenToBookmarkChanges(this.repository);
  final MovieRepository repository;

  @override
  Future<Result<Stream<int>>> call(NoParams params) async {
    return Success(repository.bookmarkStatusStream);
  }

  Stream<int> listen() {
    return repository.bookmarkStatusStream;
  }
}
