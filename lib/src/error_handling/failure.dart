import 'package:equatable/equatable.dart';

/// Provides details of the failure.
class Failure<E> extends Equatable {
  final String message;
  final E exception;
  final StackTrace? stackTrace;

  const Failure(
    this.message,
    this.exception, [
    this.stackTrace,
  ]);

  @override
  List<Object?> get props => [message, exception, stackTrace];
}
