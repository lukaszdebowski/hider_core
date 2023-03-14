import 'package:flutter/material.dart';

import 'failure.dart';

/// Class that represents a call to a resource that can fail.
/// Typically used to represent an external API call result, or a call to a plugin like a camera.
@immutable
abstract class Result<V, E> {
  /// Whether the result is successful.
  ///
  /// To retrieve the results data/failure use the [when] method.
  bool get isSuccessful;

  const factory Result.success(V data) = SuccessfulResult;

  factory Result.failure(
    String message,
    E error, [
    StackTrace? stackTrace,
  ]) = FailureResult;

  /// Calls [when]'s success callback if all [results] are successful,
  /// otherwise calls failure callback with the first [Failure] object.
  ///
  /// Thanks to that we can handle multiple results at once
  /// ```
  /// Results.all([result1, result2]).when(
  ///   success: (data) {
  ///     print("result 1: ${data[0]}");
  ///     print("result 2: ${data[1]}");
  ///   },
  ///   failure: (failure) {
  ///     print("Something went wrong. ${failure.message}");
  ///   }
  /// )
  /// ```
  /// This can simplifies the handling of actions that requires multiple
  /// dependencies:
  /// ```
  /// final successful = Results.all(results).when(
  ///   success: (_) => true,
  ///   failure: (_) => false,
  /// );
  /// ```
  static Result<List<V>, E> all<V, E>(List<Result<V, E>> results) =>
      AllResults<V, E>(results);

  T when<T>({
    required T Function(V data) success,
    required T Function(Failure<E> failure) failure,
  });
}

class FailureResult<V, E> implements Result<V, E> {
  final Failure<E> failure;

  FailureResult(
    String message,
    E error, [
    StackTrace? stackTrace,
  ]) : failure = Failure<E>(message, error, stackTrace);

  @override
  bool get isSuccessful => false;

  @override
  T when<T>({
    required T Function(V data) success,
    required T Function(Failure<E> failure) failure,
  }) {
    return failure(this.failure);
  }
}

class SuccessfulResult<V, E> implements Result<V, E> {
  const SuccessfulResult(this.data);

  @override
  bool get isSuccessful => true;

  final V data;

  @override
  T when<T>({
    required T Function(V data) success,
    required T Function(Failure<E> failure) failure,
  }) {
    return success(data);
  }
}

class AllResults<V, E> implements Result<List<V>, E> {
  final List<Result<V, E>> _results;
  List<Result<V, E>> get results => List.unmodifiable(_results);

  const AllResults(this._results);

  @override
  bool get isSuccessful => results.every((r) => r.isSuccessful);

  @override
  T when<T>({
    required T Function(List<V> data) success,
    required T Function(Failure<E> failure) failure,
  }) {
    if (isSuccessful) {
      final data =
          results.cast<SuccessfulResult<V, E>>().map((r) => r.data).toList();
      return success(data);
    } else {
      final firstFailure = results.whereType<Failure<E>>().first;
      return failure(firstFailure);
    }
  }
}
