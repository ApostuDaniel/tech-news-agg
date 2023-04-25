import 'package:shared_preferences/shared_preferences.dart';

class Config {
  static const String appName = "Tech News Agg";
  static const String apiURL = '127.0.0.1:3000';
  static const loginAPI = "/login";
  static const registerAPI = "/signup";
  static const feedsEndpoint = "/feeds";
  static const feedContentAPI = "/feed-content";
  static SharedPreferences? storage;
  static initStorage() async {
    storage ??= await SharedPreferences.getInstance();
  }
}
