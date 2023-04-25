class FeedContentModel {
  String? title;
  String? description;
  List<Items>? items;

  FeedContentModel({this.title, this.description, this.items});

  FeedContentModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? title;
  String? description;
  String? author;
  List<String>? categories;
  DateTime? date;
  String? link;

  Items(
      {this.title,
      this.description,
      this.author,
      this.categories,
      this.date,
      this.link});

  Items.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    author = json['author'];
    categories = json['categories'].cast<String>();
    date = DateTime.parse(json['date']);
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['author'] = this.author;
    data['categories'] = this.categories;
    data['date'] = this.date?.toIso8601String();
    data['link'] = this.link;
    return data;
  }
}
