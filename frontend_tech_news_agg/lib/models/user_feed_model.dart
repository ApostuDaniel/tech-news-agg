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
}

class Feed {
  late String name;
  late String feedLink;
  String? imageLink;

  Feed({required this.name, required this.feedLink, this.imageLink});

  Feed.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    feedLink = json['feed_link'];
    imageLink = json['image_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['feed_link'] = this.feedLink;
    data['image_link'] = this.imageLink;
    return data;
  }
}
