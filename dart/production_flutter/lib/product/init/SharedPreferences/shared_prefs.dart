import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  Future<String?> getCanikId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('canikId');
  }
}
