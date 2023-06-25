import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;

Future<SharedPreferences?> getPrefs() async {
  prefs ??= await SharedPreferences.getInstance();
  return prefs;
}

Future<bool> checkLogin() async {
  final SharedPreferences? prefs = await getPrefs();
  final String? userId = prefs?.getString('userId');
  return userId != null;
}

Future<void> login(String userId) async {
  final SharedPreferences? prefs = await getPrefs();
  prefs?.setString('userId', userId);
}

Future<void> logout() async {
  final SharedPreferences? prefs = await getPrefs();
  prefs?.remove('userId');
}
