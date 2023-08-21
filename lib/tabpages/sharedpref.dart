import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  sharedPrefInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }

  Future<bool> checkValuePresent(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkValuePresent = prefs.containsKey('$key');
    return checkValuePresent;
  }

  saveCred({required String email, required String password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('password', password);
    
  }

  Future<String?> getCred(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final result = prefs.getString('$key');
      return result;
    } catch (e) {
      return 'Error Fetching Data';
    }
  }

  reset() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('password');
  }
}