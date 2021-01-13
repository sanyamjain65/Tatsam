import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  //use this sharedPreferenceInstance variable from any class to access its methods...
  //static final SharedPreferencesHelper instance = SharedPreferencesHelper._();

  SharedPreferences _sharedPreferences;

  Future<SharedPreferences> get sharedPreferences async {
    if (_sharedPreferences != null) {
      return _sharedPreferences;
    }
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences;
  }

  Future<String> getString(String key) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.getString(key);
  }

  Future<bool> setString(String key, String value) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.setString(key, value);
  }
}
