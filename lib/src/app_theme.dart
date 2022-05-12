import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

/// Class holding the theme of the app.
/// It subscribes to system's theme changes and notifies it's listeners.
class AppTheme<T> extends ChangeNotifier {
  AppTheme({
    required T darkThemeData,
    required T lightThemeData,
  })  : _darkThemeData = darkThemeData,
        _lightThemeData = lightThemeData,
        _themeMode = _storage.get(ThemeMode, defaultValue: ThemeMode.system) {
    WidgetsBinding.instance.window.onPlatformBrightnessChanged = notifyListeners;
  }

  /// True if [themeMode] is set to [ThemeMode.dark] or to [ThemeMode.system] and underlying system is set to dark theme.
  bool get isDarkTheme =>
      _themeMode == ThemeMode.dark ||
      (_themeMode == ThemeMode.system &&
          WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark);

  /// Current theme mode used by the app.
  ThemeMode get themeMode => _themeMode;

  /// Returns [darkThemeData] or [lightThemeData], based on the value of [isDarkTheme].
  T get data => isDarkTheme ? _darkThemeData : _lightThemeData;

  /// Sets the theme mode for the app and notifies listeners.
  Future<void> setThemeMode(ThemeMode mode) async {
    await _storage.put(ThemeMode, mode);
    _themeMode = mode;
    notifyListeners();
  }

  /// Allows to read AppTheme without context, but does not subscribe to changes.
  ///
  /// Prefer using the [of] method instead, to have the most up to date version of theme.
  static late AppTheme instance;

  /// Reads the AppTheme and subscribes to changes, if [listen] is true.
  static AppTheme<T> of<T>(BuildContext context, {bool listen = true}) {
    final appTheme = Provider.of<AppTheme<T>>(context, listen: listen);
    AppTheme.instance = appTheme;
    return appTheme;
  }

  static final _storage = Hive.box('AppThemeBox');

  ThemeMode _themeMode;

  final T _darkThemeData;
  final T _lightThemeData;
}
