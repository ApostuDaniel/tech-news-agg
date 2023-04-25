import 'dart:convert';

import 'package:frontend_tech_news_agg/models/feed_content_model.dart';
import 'package:frontend_tech_news_agg/models/login_request_model.dart';
import 'package:frontend_tech_news_agg/models/login_response_model.dart';
import 'package:frontend_tech_news_agg/models/register_request_model.dart';
import 'package:frontend_tech_news_agg/models/user_feed_model.dart';
import 'package:http/http.dart' as http;

import '../../config.dart';
import 'shared_service.dart';

class APIService {
  static var client = http.Client();

  static Future<bool> login(
    LoginRequestModel model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.loginAPI,
    );

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      await SharedService.setLoginDetails(
          LoginResponseModel.fromJson(json.decode(response.body)));

      return true;
    } else {
      return false;
    }
  }

  static Future<bool> register(
    RegisterRequestModel model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.registerAPI,
    );

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  // static Future<String> getUserProfile() async {
  //   var loginDetails = await SharedService.loginDetails();

  //   Map<String, String> requestHeaders = {
  //     'Content-Type': 'application/json',
  //     'Authorization': loginDetails!.token
  //   };

  //   var url = Uri.http(Config.apiURL, Config.userProfileAPI);

  //   var response = await client.get(
  //     url,
  //     headers: requestHeaders,
  //   );

  //   if (response.statusCode == 200) {
  //     return response.body;
  //   } else {
  //     return "";
  //   }
  // }

  static Future<UserFeeds> getUserFeeds() async {
    var loginDetails = await SharedService.loginDetails();
    var userIdentification = await SharedService.userIdentification();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': loginDetails!.token
    };

    var url = Uri.http(
        Config.apiURL, "${Config.feedsEndpoint}/${userIdentification?.userId}");

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      return UserFeeds.fromJson(json.decode(response.body));
    }
    throw Exception(response.body);
  }

  static Future<List<Feed>> getAllFeeds() async {
    var url = Uri.http(Config.apiURL, Config.feedsEndpoint);

    var response = await client.get(url);

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((i) => Feed.fromJson(i))
          .toList();
    }
    throw Exception(response.body);
  }

  static Future<FeedContentModel> getFeedContent(String feedURL) async {
    var url =
        Uri.http(Config.apiURL, Config.feedContentAPI, {"feed_link": feedURL});
    // }${Uri.decodeComponent("?feed_link=")}${Uri.encodeComponent(feedURL)}"

    var response = await client.get(url);

    if (response.statusCode == 200) {
      return FeedContentModel.fromJson(json.decode(response.body));
    }
    throw Exception(response.body);
  }
}
