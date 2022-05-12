import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Class holding the theme of the app.
/// It subscribes to system's theme changes and notifies it's listeners.
class AppTheme<T> extends ChangeNotifier {
  AppTheme({
    required T darkThemeData,
    required T lightThemeData,
  })  : _darkThemeData = darkThemeData,
        _lightThemeData = lightThemeData,
        _themeMode = _initialThemeMode {
    WidgetsBinding.instance.window.onPlatformBrightnessChanged = notifyListeners;
  }

  /// Call this method before you run [runApp].
  static Future<void> init() async {
    _storage = await SharedPreferences.getInstance();
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
    await _storage.setString(_themeModeKey, mode.name);
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

  static late final SharedPreferences _storage;

  ThemeMode _themeMode;

  final T _darkThemeData;
  final T _lightThemeData;

  static ThemeMode get _initialThemeMode {
    return ThemeMode.values.byName(_storage.getString(_themeModeKey) ?? 'system');
  }
}

const String _themeModeKey = 'ThemeMode';
