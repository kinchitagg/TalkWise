import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction{
  static String sharedPreferencesUserLoginKey = "ISLOGINKEY";
  static String sharedpreferencesUsernameKey = "USERNAMEKEY";
  static String sharedpreferencesEmailKey = "EMAILKEY";

  //saving data to shared preferences
 static Future<void> saveUserLoginKeySharedPreferences(bool isUserLogined) async{
   SharedPreferences preferences = await SharedPreferences.getInstance();
   return await preferences.setBool(sharedPreferencesUserLoginKey, isUserLogined);
 }

 static Future<void> saveUsernameSharedPreferences(String username) async {
   SharedPreferences preferences = await SharedPreferences.getInstance();
   return await preferences.setString(sharedpreferencesUsernameKey, username);
 }

  static Future<void> saveEmailSharedPreferences(String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedpreferencesEmailKey, email);
  }

  //getting data from shared preferences
  static Future<bool> getUserLoginKeySharedPreferenced ()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(sharedPreferencesUserLoginKey);
  }

  static Future<String> getUsernameSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedpreferencesUsernameKey);
  }
  static Future<String> getEmailSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedpreferencesEmailKey);
  }

}