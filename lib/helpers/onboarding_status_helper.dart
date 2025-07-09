import 'package:shared_preferences/shared_preferences.dart';

Future<bool> getOnboardingStatus() async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getBool('hasSeenOnboarding') ?? false;
}

Future<void> saveOnboardingStatus() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool('hasSeenOnboarding', true);
}
