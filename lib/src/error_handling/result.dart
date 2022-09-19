import 'failure.dart';

/// Class that represents a call to a resource that can fail.
/// Typically used to represent an external API call result, or a call to a plugin like a camera.
class Result<T> {
  const Result._(this.data, this.failure);

  final T? data;
  final Failure? failure;

  bool get isSuccessful => failure == null;
  bool get isFailed => !isSuccessful;

  factory Result.success([T? data]) => Result._(data, null);

  factory Result.failure(Failure failure) => Result._(null, failure);

  S when<S>({
    required S Function(T data) success,
    required S Function(Failure failure) failure,
  }) {
    if (isSuccessful) {
      return success(data as T);
    } else {
      return failure(this.failure!);
    }
  }
}
