import 'package:equatable/equatable.dart';

class Failure<T extends Object> extends Equatable {
  const Failure({
    required this.message,
    this.exception,
    this.stackTrace,
    this.failedValue,
  });

  final String message;
  final Exception? exception;
  final StackTrace? stackTrace;
  final T? failedValue;

  @override
  List<Object?> get props => [message, exception, failedValue, stackTrace];

}

