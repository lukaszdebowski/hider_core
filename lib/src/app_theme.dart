import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Class holding the theme of the app.
/// It subscribes to system's theme changes and notifies it's listeners.
class AppTheme<T> extends ChangeNotifier {
  AppTheme({
    required T darkThemeData,
    required T lightThemeData,
  })  : _darkThemeData = darkThemeData,
        _lightThemeData = lightThemeData {
    WidgetsBinding.instance.window.onPlatformBrightnessChanged = notifyListeners;
  }

  final T _darkThemeData;
  final T _lightThemeData;

  /// True if the underlying system is set to dark theme.
  bool get isDarkTheme => WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;

  ThemeMode get themeMode => isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  /// Returns [darkThemeData] or [lightThemeData], based on the value of [isDarkTheme]
  T get data => isDarkTheme ? _darkThemeData : _lightThemeData;

  /// Allows to read AppTheme without context, but does not subscribe to changes.
  ///
  /// Prefer using the [of] method instead, to have the most up to date version of theme.
  static late AppTheme instance;

  /// Reads the AppTheme and subscribes to changes
  static AppTheme of(BuildContext context, {bool listen = true}) {
    final appTheme = Provider.of<AppTheme>(context, listen: listen);
    AppTheme.instance = appTheme;
    return appTheme;
  }
}
