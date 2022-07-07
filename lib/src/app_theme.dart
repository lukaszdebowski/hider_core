part of 'app_theme_provider.dart';

/// Class holding the theme of the app.
/// It subscribes to system's theme changes and notifies it's listeners.
class AppTheme<T> extends ChangeNotifier {
  AppTheme({
    required this.themeDataModes,
    required this.reactsToSystemChanges,
  }) {
    _themeDataMode = _initialThemeDataMode;
    if (reactsToSystemChanges) {
      WidgetsBinding.instance.window.onPlatformBrightnessChanged = _onPlatformBrightnessChanged;
    }
  }

  /// Call this method before you run [runApp].
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _storage = await SharedPreferences.getInstance();
  }

  bool get isDarkTheme => _themeDataMode == _darkThemeKey;

  /// Current theme mode used by the app. This is one of the keys in [themeDataModes].
  String get themeDataMode => _themeDataMode;

  /// True if the app is following the system theme changes.
  bool get followsSystem => !_storage.containsKey(_themeDataModeKey) && reactsToSystemChanges;

  T get data => themeDataModes[_themeDataMode]!;

  /// Sets the theme mode for the app and notifies listeners.
  Future<void> setThemeMode(String mode) async {
    if (!themeDataModes.containsKey(mode)) {
      throw Exception('$mode has to be one of supported values: ${themeDataModes.keys}');
    }

    await _storage.setString(_themeDataModeKey, mode);
    _themeDataMode = mode;
    notifyListeners();
  }

  Future<void> followSystem() async {
    await _storage.remove(_themeDataModeKey);
    _themeDataMode = _initialThemeDataMode;
    notifyListeners();
  }

  void _onPlatformBrightnessChanged() {
    final String? storedThemeDataMode = _storage.getString(_themeDataModeKey);
    if (storedThemeDataMode == null) {
      followSystem();
    }
  }

  /// Reads the AppTheme and subscribes to changes, if [listen] is true.
  static AppTheme<T> of<T>(BuildContext context, {bool listen = true}) {
    final appTheme = Provider.of<AppTheme<T>>(context, listen: listen);
    return appTheme;
  }

  static late final SharedPreferences _storage;

  late String _themeDataMode;

  final Map<String, T> themeDataModes;
  final bool reactsToSystemChanges;

  String get _initialThemeDataMode {
    final bool systemSetToDark = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    final bool darkThemeModeProvided = themeDataModes.containsKey(_darkThemeKey);
    final String defaultDataMode = systemSetToDark && darkThemeModeProvided ? _darkThemeKey : _lightThemeKey;
    try {
      final String storedThemeDataMode = _storage.getString(_themeDataModeKey) ?? defaultDataMode;
      if (themeDataModes.containsKey(storedThemeDataMode)) {
        return storedThemeDataMode;
      } else {
        return defaultDataMode;
      }
    } catch (_) {
      return defaultDataMode;
    }
  }
}

const String _themeDataModeKey = 'theme_data_mode';
const String _darkThemeKey = 'dark';
const String _lightThemeKey = 'light';
