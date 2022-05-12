import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  const Failure({required this.message, this.exception});

  final String message;
  final Exception? exception;

  @override
  List<Object?> get props => [message, exception];
}
