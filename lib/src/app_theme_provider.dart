import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_theme.dart';

typedef AppThemeBuilder<T> = Widget Function(AppTheme<T> theme);

/// Provides [AppTheme] down the tree for access via [AppTheme.of].
/// 
/// This should be wrapped around your [MaterialApp] widget.
class AppThemeProvider<T> extends StatelessWidget {
  const AppThemeProvider({
    Key? key,
    required this.builder,
    required this.lightThemeData,
    required this.darkThemeData,
  }) : super(key: key);

  final AppThemeBuilder<T> builder;
  final T darkThemeData;
  final T lightThemeData;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme<T>(
        lightThemeData: lightThemeData,
        darkThemeData: darkThemeData,
      ),
      child: Builder(
        builder: (context) {
          return builder(AppTheme.of<T>(context));
        },
      ),
    );
  }
}
