## Getting started

This is a sample architecture of a flutter app. 
The core features that most apps need:

- ViewModel class, which is responsible for presentation logic and delegating user actions to repositories and/or service classes
- View <> ViewModel bindings, ("bloc" one could say)


- Result class - compile time safe way of handling async errors, instead of try catche hell :) 
- Failure class - base class for every failure/error/exception that might happen in repositories/view models

- Application theme'ing support, with dark/light/custom themes support

## Usage


```dart

// Example method in most "outside world facing" layer, i.e service class
Future<Result<String>> exampleAsyncMethod() async {
  try {
    final httpResult = await http.get('...');
    
    if (httpResult.status == 200) {
      return Result.success("All good!");
    } else {
      // The result class implicitly expects an instance of Failure on the .failure factory
      return Result.failure(Failure.exampleAsyncMethodFailed(httpResult.status));
    }
  } catch (e) {
    return Result.failure(Failure.unknownFailure(e));
  }
}

// Somewhere in the ViewModel or repository
Future<void> handleUserTap() async {

  // Get the compile safe async result, no try catches needed
  final Result<bool> result = await _service.exampleAsyncMethod();
  
  // Get the data or the failure, both handlers are mandatory so it's impossible not to handle the "error" case
  final String message = result.when(
    (data) => data,
    (failure) => "something went wrong",
  );
  
  // Do something with the result
  emitState(message: message);
}

```

## Additional information

This package is a minimal set of functionalities. Additional features may or may not be added.
