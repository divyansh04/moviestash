import '../utils/result.dart';

abstract class UseCase<Type, Params> {
  Future<Result<Type>> call(Params params);
}

class NoParams {
  const NoParams();
}

class PaginationParams {

  const PaginationParams({required this.page});
  final int page;
}
