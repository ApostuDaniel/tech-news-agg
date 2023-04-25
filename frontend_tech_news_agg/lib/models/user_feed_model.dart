class UserFeeds {
  String? user;
  List<Feed>? feeds;

  UserFeeds({this.user, this.feeds});

  UserFeeds.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    if (json['feeds'] != null) {
      feeds = <Feed>[];
      json['feeds'].forEach((v) {
        feeds!.add(Feed.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = this.user;
    if (this.feeds != null) {
      data['feeds'] = this.feeds!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toJsonPut() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = this.user;
    if (this.feeds != null) {
      data['feeds'] = this.feeds!.map((v) => v.sId).toList();
    }
    return data;
  }
}

class Feed {
  late String sId;
  late String name;
  late String feedLink;
  String? imageLink;

  Feed({required this.name, required this.feedLink, this.imageLink});

  Feed.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sId = json['_id'];
    feedLink = json['feed_link'];
    imageLink = json['image_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['feed_link'] = this.feedLink;
    data['image_link'] = this.imageLink;
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Feed &&
        other.sId == sId &&
        other.name == name &&
        other.feedLink == feedLink &&
        other.imageLink == imageLink;
  }

  @override
  int get hashCode =>
      sId.hashCode ^ name.hashCode ^ feedLink.hashCode ^ imageLink.hashCode;
}
