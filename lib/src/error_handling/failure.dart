abstract class Failure<T> {
  String get message;
  Exception? get exception;
  StackTrace? get stackTrace;
  T? get value;
}
