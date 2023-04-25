import 'dart:convert';

// import 'package:api_cache_manager/api_cache_manager.dart';
// import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter/material.dart';
import 'package:frontend_tech_news_agg/models/jwt_payload_model.dart';
import 'package:frontend_tech_news_agg/models/login_response_model.dart';
import '../config.dart';

class SharedService {
  static Future<bool> isLoggedIn() async {
    // var isCacheKeyExist =
    //     await APICacheManager().isAPICacheKeyExist("login_details");

    // return isCacheKeyExist;
    bool keyExists = (Config.storage?.getString("login_details")) != null;
    return keyExists;
  }

  static Future<LoginResponseModel?> loginDetails() async {
    String? loginDetails = Config.storage?.getString("login_details");
    if (loginDetails != null) {
      return LoginResponseModel.fromJson(json.decode(loginDetails));
    }
  }

  static Future<JwtPayload?> userIdentification() async {
    // var isCacheKeyExist =
    //     await APICacheManager().isAPICacheKeyExist("user_identification");

    // if (isCacheKeyExist) {
    //   var cacheData =
    //       await APICacheManager().getCacheData("user_identification");

    //   return JwtPayload.fromJson(json.decode(cacheData.syncData));
    // }
    String? userId = Config.storage?.getString("user_identification");
    if (userId != null) {
      return JwtPayload.fromJson(json.decode(userId));
    }
  }

  static Future<void> setLoginDetails(
    LoginResponseModel loginResponse,
  ) async {
    // APICacheDBModel loginModel = APICacheDBModel(
    //   key: "login_details",
    //   syncData: jsonEncode(loginResponse.toJson()),
    // );
    // String jwt = loginResponse.token;
    // JwtPayload payload = JwtPayload.fromJWT(jwt);

    // APICacheDBModel userIdModel = APICacheDBModel(
    //   key: "user_identification",
    //   syncData: jsonEncode(payload.toJson()),
    // );

    // await APICacheManager().addCacheData(loginModel);
    // await APICacheManager().addCacheData(userIdModel);
    await Config.storage
        ?.setString("login_details", jsonEncode(loginResponse.toJson()));

    String jwt = loginResponse.token;
    JwtPayload payload = JwtPayload.fromJWT(jwt);

    await Config.storage
        ?.setString("user_identification", jsonEncode(payload.toJson()));
  }

  static Future<void> logout(BuildContext context) async {
    await Config.storage?.remove("login_details");
    await Config.storage?.remove("user_identification");
    // await APICacheManager().deleteCache("login_details");
    // await APICacheManager().deleteCache("user_identification");
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }
}
