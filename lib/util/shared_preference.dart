import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefrence {
  static Future<bool> isUserLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isUserLogIn');
  }

  static Future<void> setUserLogIn(bool b) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool('isUserLogIn', b);
  }

  static Future<void> setDisplayName(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('displayName', token);
  }

  static Future<String> getDisplayName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('displayName');
  }

  static Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isUserLogIn', false);
    prefs.setString('displayName', '');
    prefs.setString('profileImage', '');
    prefs.setString('email', '');
  }

  static Future<void> setEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('email', email);
  }

  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  static Future<String> getProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("profileImage");
  }

  static Future<void> setProfileImage(String profileImage) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('profileImage', profileImage);
  }

  static Future<String> getMobileNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("mobileNumber");
  }

  static Future<void> setMobileNumber(String memberCode) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('mobileNumber', memberCode);
  }

}
