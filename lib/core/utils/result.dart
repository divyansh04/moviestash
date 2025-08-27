import 'package:equatable/equatable.dart';
import '../error/exceptions.dart';

abstract class Result<T> extends Equatable {
  const Result();
}

class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;

  @override
  List<Object?> get props => [data];
}

class Failure<T> extends Result<T> {
  const Failure(this.exception);
  final AppException exception;

  @override
  List<Object?> get props => [exception];
}

extension ResultExtensions<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get data => isSuccess ? (this as Success<T>).data : null;
  AppException? get exception =>
      isFailure ? (this as Failure<T>).exception : null;

}
