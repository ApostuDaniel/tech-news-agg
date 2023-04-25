import 'dart:convert';

class JwtPayload {
  String? username;
  String? userId;

  JwtPayload({this.username, this.userId});

  JwtPayload.fromJWT(String jwt) {
    Map<String, dynamic> payload = json
        .decode(utf8.decode(base64Decode(base64.normalize(jwt.split(".")[1]))));
    username = payload['username'];
    userId = payload['userId'];
  }

  JwtPayload.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['userId'] = this.userId;
    return data;
  }
}
