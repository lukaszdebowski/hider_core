import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_controller.dart';

typedef ViewBindingViewBuilder<T> = Widget Function(BuildContext, T, Widget?);

typedef ViewBindingControllerBuilder<T> = T Function(BuildContext);

/// Widget that ties view to a [ViewController].
class ViewBinding<T extends ViewController> extends StatelessWidget {
  const ViewBinding({
    Key? key,
    required this.viewBuilder,
    required this.controllerBuilder,
    this.reactive = true,
    this.staticChild,
  }) : super(key: key);

  /// View builder that will get rebuild when controller notifies it's listeners, if [reactive] is set to true.
  final ViewBindingViewBuilder<T> viewBuilder;

  /// Callback that returns the controller for the view.
  final ViewBindingControllerBuilder<T> controllerBuilder;

  /// If true, the [viewBuilder] will be called when controller notifies it's listeners.
  final bool reactive;

  /// Widget that is built only once and passed down to the builder, for performance optimizations if part of the widget tree does not need to rebuild when controller notifies it's listeners.
  final Widget? staticChild;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      lazy: false,
      create: controllerBuilder,
      builder: (context, _) {
        final T controller = Provider.of<T>(context, listen: reactive);
        return viewBuilder(context, controller, staticChild);
      },
    );
  }
}
