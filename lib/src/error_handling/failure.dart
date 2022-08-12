import 'package:equatable/equatable.dart';

/// Extend this class to implement project specific Failures
abstract class Failure<T> extends Equatable {
  const Failure({
    required this.code,
    required this.debugMessage,
    this.exception,
    this.stackTrace,
    this.details,
  });

  final String code;
  final String debugMessage;
  final Exception? exception;
  final StackTrace? stackTrace;
  final T? details;

  @override
  List<Object?> get props => [debugMessage, exception, stackTrace, details];
}
