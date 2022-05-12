import 'failure.dart';


/// Class that represents a call to a resource that can fail. 
/// Typically used to represent an API call result, to provide typesafe access.
class Result<T> {
  const Result._(this.data, this.failure);

  final T? data;
  final Failure? failure;

  bool get isSuccessul => data != null;

  factory Result.success(T data) => Result._(data, null);

  factory Result.failure(Failure failure) => Result._(null, failure);

  S when<S>({required S Function(T data) success, required S Function(Failure failure) failure}) {
    if (isSuccessul) {
      return success(data as T);
    } else {
      return failure(this.failure!);
    }
  }

  Result<S> mapData<S>(S Function(T data) dataConverter) {
    return when(
      success: (data) => Result.success(dataConverter(data)),
      failure: (failure) => Result.failure(failure),
    );
  }
}
