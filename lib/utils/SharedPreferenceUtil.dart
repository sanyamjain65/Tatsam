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

  Future<dynamic> getValueOf(String key) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.get(key);
  }

  Future<String> getString(String key) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.getString(key);
  }

  Future<bool> getBool(String key) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.getBool(key);
  }

  Future<double> getDouble(String key) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.getDouble(key);
  }

  Future<int> getInt(String key) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.getInt(key);
  }

  Future<List<String>> getStringList(String key) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.getStringList(key);
  }

  Future<Set<String>> getAllKeys() async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.getKeys();
  }

  Future<bool> containsKeys(String key) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.containsKey(key);
  }

  Future<bool> setString(String key, String value) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.setString(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.setBool(key, value);
  }

  Future<bool> setInt(String key, int value) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.setInt(key, value);
  }

  Future<bool> setDouble(String key, double value) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.setDouble(key, value);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.setStringList(key, value);
  }

  Future<bool> remove(String key) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.remove(key);
  }

  Future<bool> clear() async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.clear();
  }
}
