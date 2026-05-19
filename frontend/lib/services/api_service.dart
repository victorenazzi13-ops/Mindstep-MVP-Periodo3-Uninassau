import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  static String? token;
  static String? userName;

  static Future<void> saveSession(String newToken, String newUserName) async {
    token = newToken;
    userName = newUserName;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', newToken);
    await prefs.setString('userName', newUserName);
  }

  static Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();

    token = prefs.getString('token');
    userName = prefs.getString('userName');
  }

  static Future<void> clearSession() async {
    token = null;
    userName = null;

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('token');
    await prefs.remove('userName');
  }
}