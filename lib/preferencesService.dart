import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';
class PrefrencesServices {
  Future<void> saveSettings(Settings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', settings.email);
    await prefs.setString('password', settings.password);
    await prefs.setBool('isChecked', settings.isChecked);
    print("saved settings");
  }

  Future<Settings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    final isChecked = prefs.getBool('isChecked');

    return Settings(email: email.toString(), password: password.toString(),isChecked:isChecked!);
  }
}
