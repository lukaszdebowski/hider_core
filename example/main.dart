// ignore_for_file: avoid_print

import 'package:hider_core/error_handling.dart';

class AuthException implements Exception {
  final String code;
  final String message;

  const AuthException({
    required this.code,
    required this.message,
  });

  @override
  String toString() {
    return 'AuthException { code: $code, message: $message }';
  }
}

class User {
  final String fistName;
  final String lastName;

  const User({
    required this.fistName,
    required this.lastName,
  });

  @override
  String toString() {
    return 'User { firstName: $fistName, lastName: $lastName }';
  }
}

void onSuccess(User user) {
  print("SUCCESS: $user");
}

void onSuccessAll(List<User> users) {
  print("SUCCESS_ALL: $users");
}

void onFailure(Failure<AuthException> failure) {
  print("FAILURE: ${failure.message}; ${failure.exception}");
}

void main() {
  final wrongCredentials = Result<User, AuthException>.failure(
    'Error during the user login.',
    const AuthException(
      code: 'WRONG_CREDENTIALS',
      message: 'The provided credentials do not exist in our system',
    ),
  );
  wrongCredentials.when(success: onSuccess, failure: onFailure);

  final userNotFound = Result<User, AuthException>.failure(
    'Error during the user login.',
    const AuthException(
      code: 'USER_NOT_FOUND',
      message: 'User not found',
    ),
  );
  userNotFound.when(success: onSuccess, failure: onFailure);

  final unknown = Result<User, AuthException>.failure(
    'Error during the user login.',
    const AuthException(
      code: 'UNKNOWN_AUTH_ERROR',
      message: 'Something unexpected happened here',
    ),
  );
  unknown.when(success: onSuccess, failure: onFailure);

  const successful = Result<User, AuthException>.success(
    User(fistName: 'John', lastName: 'Foo'),
  );
  successful.when(success: onSuccess, failure: onFailure);

  Result.all([wrongCredentials, userNotFound, unknown, successful]).when(
    success: onSuccessAll,
    failure: onFailure,
  );
}
