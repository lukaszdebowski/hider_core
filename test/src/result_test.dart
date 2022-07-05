import 'package:flutter_test/flutter_test.dart';
import 'package:hider_core/hider_core.dart';

void main() {
  group('Result -', () {
    test("Result.success() creates a successful instance", () {
      final result = Result.success(100);

      expect(result.isSuccessul, true);
      expect(result.failure, null);
    });

    test("Result.failure() creates an invalid instance", () {
      const failure = Failure(message: "failed");
      final result = Result.failure(failure);

      expect(result.isSuccessul, false);
      expect(result.failure, failure);
    });

    test("data is null for invalid instance", () {
      final result = Result.failure(const Failure(message: "failed"));

      expect(result.data, null);
    });

    test("failure is null for valid instance", () {
      final result = Result.success(100);

      expect(result.failure, null);
    });

    test("when() returns the data when Result is valid", () {
      final result = Result.success(100).when(success: (data) => data, failure: (failure) => failure);

      expect(result, 100);
    });

    test("when() returns the failure when Result is invalid", () {
      final result = Result.failure(const Failure(message: "failed")).when(
        success: (data) => data,
        failure: (failure) => failure,
      );

      expect(result, const Failure(message: "failed"));
    });
  });
}
