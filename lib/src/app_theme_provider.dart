import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_theme.dart';

typedef WidgetBuilderWithTheme<T> = Widget Function(AppTheme<T> theme);

/// Provides [AppTheme] down the tree for access via [AppTheme.of].
///
/// This should be wrapped around your [MaterialApp] widget.
class AppThemeProvider<T extends Object> extends StatelessWidget {
  AppThemeProvider({
    Key? key,
    required this.builder,
    required this.themeDataModes,
    this.reactsToSystemChanges = true,
  })  : assert(themeDataModes.containsKey(_lightThemeKey), "themeDataModes has to support at least light mode"),
        super(key: key);

  final WidgetBuilderWithTheme<T> builder;

  /// A map of supported theme modes in the app. Should at least contain the key 'light'.
  ///
  /// In case the app should support dark theme, the map should also contain the key 'dark'.
  final Map<String, T> themeDataModes;

  /// Whether the app should be reacting to system's theme changes.
  final bool reactsToSystemChanges;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme<T>(
        themeDataModes: themeDataModes,
        reactsToSystemChanges: reactsToSystemChanges,
      ),
      child: Builder(
        builder: (context) {
          return builder(AppTheme.of<T>(context));
        },
      ),
    );
  }
}
