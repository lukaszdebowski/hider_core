import 'package:flutter_test/flutter_test.dart';
import 'package:hider_core/hider_core.dart';

void main() {
  group('Failure -', () {
    test("supports value comparison", () {
      // ignore: prefer_const_declarations
      final value = 5;
      final failure = Failure(message: "Value is $value", failedValue: value);

      expect(failure, const Failure(message: "Value is 5", failedValue: 5));
    });
  });
}
