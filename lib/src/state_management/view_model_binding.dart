import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model.dart';

typedef ViewBuilder<T> = Widget Function(BuildContext, T, Widget?);

typedef ViewModelBuilder<T> = T Function(BuildContext);

/// Widget that ties a view to a [ViewModel].
class ViewModelBinding<T extends ViewModel> extends StatelessWidget {
  const ViewModelBinding({
    Key? key,
    required this.viewBuilder,
    required this.viewModelBuilder,
    this.reactive = true,
    this.staticChild,
  }) : super(key: key);

  /// View builder that will get rebuild when [ViewModel] notifies it's listeners, if [reactive] is set to true.
  final ViewBuilder<T> viewBuilder;

  /// Callback that returns the [ViewModel] for the view.
  final ViewModelBuilder<T> viewModelBuilder;

  /// If true, the [viewBuilder] will be called when controller notifies it's listeners.
  final bool reactive;

  /// Widget that is built only once and passed down to the builder, for performance optimizations if part of the widget tree does not need to rebuild when [ViewModel] notifies it's listeners.
  final Widget? staticChild;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      lazy: false,
      create: viewModelBuilder,
      builder: (context, _) {
        final T controller = Provider.of<T>(context, listen: reactive);
        return viewBuilder(context, controller, staticChild);
      },
    );
  }
}
