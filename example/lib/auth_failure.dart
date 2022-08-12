import 'package:hider_core/error_handling.dart';

/// Example usage.
class AuthFailure extends Failure {
  const AuthFailure._internal({
    required super.code,
    required super.debugMessage,
    super.exception,
    super.stackTrace,
    super.details,
  });

  factory AuthFailure.userNotFound() {
    return const AuthFailure._internal(
      code: 'USER_NOT_FOUND',
      debugMessage: 'User not found',
    );
  }

  factory AuthFailure.wrongCredentials() {
    return const AuthFailure._internal(
      code: 'WRONG_CREDENTIALS',
      debugMessage: 'The provided credentials do not exist in our system',
    );
  }

    factory AuthFailure.unknown(Exception e, dynamic failedValue) {
    return  AuthFailure._internal(
      code: 'UNKNOWN_AUTH_ERROR',
      debugMessage: 'Something unexpected happened here',
      exception: e,
      stackTrace: StackTrace.current,
      details: failedValue,
    );
  }

  @override
  List<Object?> get props => [...super.props];
}