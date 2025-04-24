import 'package:shared_preferences/shared_preferences.dart';

class PremiumManager {
  static Future<bool> isPremium() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('premium') ?? false;
  }

  static Future<void> activatePremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('premium', true);
    await prefs.setInt('tokens', 9999);
  }
}
