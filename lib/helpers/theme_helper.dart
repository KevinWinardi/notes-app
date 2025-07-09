import 'package:shared_preferences/shared_preferences.dart';

Future<bool> getTheme() async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getBool('isDarkMode') ?? false;
}

Future<void> saveTheme(bool isDarkMode) async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool('isDarkMode', isDarkMode);
}
