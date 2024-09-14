import 'package:bloc_inspector_client/config/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferencesService._internal();

  static final SharedPreferencesService _manager =
      SharedPreferencesService._internal();

  SharedPreferences? _prefs;

  factory SharedPreferencesService() {
    return _manager;
  }

  Future<void> _ensurePrefsLoaded() async {
    _manager._prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> clearPreferences() async {
    await _manager._ensurePrefsLoaded();
  }

  Future<bool> getIsDarkMode() async {
    await _manager._ensurePrefsLoaded();
    return Future.value(_manager._prefs!.getBool(PrefKeys.isDarkMode) ?? false);
  }

  Future<void> setIsDarkMode(bool value) async {
    await _manager._ensurePrefsLoaded();
    await _manager._prefs!.setBool(PrefKeys.isDarkMode, value);
  }
}
