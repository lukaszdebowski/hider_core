import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ViewController<S> extends ChangeNotifier {
  ViewController(S initialState) : _states = [initialState];

  /// The current state stored in this ViewController.
  ///
  /// When the state is replaced with something that is not equal to the old
  /// state as evaluated by the equality operator ==, this class notifies its
  /// listeners.
  S get state => _states.last;

  final List<S> _states;

  /// Unmodifiable list of all states that were emitted by this ViewController during it's lifecycle.
  ///
  /// If subsequent states are equal as evaluated by the equality operator ==, the later state gets ignored.
  UnmodifiableListView<S> get states => UnmodifiableListView<S>(_states);

  set state(S newState) {
    if (state == newState) {
      return;
    }

    _states.add(newState);
    notifyListeners();
  }

  /// The previous state stored in this ViewController, or null if the states has only 1 value.
  S? get previousState {
    if (_states.length > 1) {
      return _states[_states.length - 2];
    } else {
      return null;
    }
  }

  @override
  String toString() => 'ViewController(state: $state, states: $states)';
}
