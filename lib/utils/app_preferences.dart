import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String HOST = "HOST";
  static const String PORT = "PORT";
  static const String AUTOMATIC_LOGIN_KEY = "automaticLoggin";
  static const String USER_NAME = "userName";
  static const String USER_PASSWORD = "userPassword";

  static SharedPreferences appPreferences;
  static Future<SharedPreferences> init() async {
    appPreferences = await SharedPreferences.getInstance();
    if(!appPreferences.containsKey(AppPreferences.HOST)) {
      appPreferences.setString(AppPreferences.HOST, "https://dev-time-tracker.cognitran-cloud.com");
    }
    if(!appPreferences.containsKey(AppPreferences.PORT)) {
      appPreferences.setInt(AppPreferences.PORT, 8080);
    }
    if(!appPreferences.containsKey(AppPreferences.AUTOMATIC_LOGIN_KEY)) {
      appPreferences.setBool(AppPreferences.AUTOMATIC_LOGIN_KEY, true);
    }

    return appPreferences;
  }
}