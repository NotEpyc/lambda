import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static SharedPreferences? _prefs;
  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // User data (for progress and preferences)
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _prefs?.setString('user_data', json.encode(userData));
  }
  
  static Map<String, dynamic>? getUserData() {
    final userDataString = _prefs?.getString('user_data');
    if (userDataString != null) {
      return json.decode(userDataString) as Map<String, dynamic>;
    }
    return null;
  }
  
  static Future<void> clearUserData() async {
    await _prefs?.remove('user_data');
  }
  
  // App settings
  static Future<void> saveSetting(String key, dynamic value) async {
    if (value is String) {
      await _prefs?.setString(key, value);
    } else if (value is int) {
      await _prefs?.setInt(key, value);
    } else if (value is double) {
      await _prefs?.setDouble(key, value);
    } else if (value is bool) {
      await _prefs?.setBool(key, value);
    } else {
      await _prefs?.setString(key, json.encode(value));
    }
  }
  
  static T? getSetting<T>(String key) {
    return _prefs?.get(key) as T?;
  }
  
  // Clear all data
  static Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
