import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_tech_news_agg/models/feed_content_model.dart';
import 'package:frontend_tech_news_agg/models/jwt_payload_model.dart';
import 'package:frontend_tech_news_agg/models/user_feed_model.dart';
import '../config.dart';
import '../services/api_service.dart';
import '../services/shared_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<UserFeeds> _userFeeds;
  late Future<List<Feed>> _allFeeds;
  // late Future<FeedContentModel> feedContent;
  late Future<JwtPayload?> _payload;
  int? feedIndex;
  // String? feedLink;
  // //  = JwtPayload.fromJson(
  // //     json.decode(Config.storage?.getString("login_details") ?? ""));

  // UserFeeds? userFeeds;
  // List<Feed>? allFeeds;
  // JwtPayload? payload;
  // FeedContentModel? feedContent;

  T? cast<T>(x) => x is T ? x : null;

  @override
  void initState() {
    super.initState();
    _userFeeds = APIService.getUserFeeds();
    _allFeeds = APIService.getAllFeeds();
    _payload = SharedService.userIdentification();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([_payload, _userFeeds]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            var payload = cast<JwtPayload>(snapshot.data![0]);
            var userFeeds = cast<UserFeeds>(snapshot.data![1]);
            if (userFeeds != null &&
                userFeeds.feeds != null &&
                (userFeeds.feeds ?? []).isNotEmpty &&
                feedIndex == null) {
              feedIndex = 0;
            }
            return Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFF283B71),
                title: Text("Welcome ${payload?.username}"),
                elevation: 0,
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/home',
                        );
                      },
                      child: const Text("Home")),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/available-feeds',
                        );
                      },
                      child: const Text("Available feeds")),
                  IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      SharedService.logout(context);
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              backgroundColor: Colors.grey[200],
              body: feedContentDisplay(userFeeds),
              drawer: Drawer(
                child: feeds(userFeeds),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }

          return const CircularProgressIndicator();
        });
  }

  Widget feedContentDisplay(UserFeeds? userFeeds) {
    if (feedIndex == null) {
      return const Center(
        child: Text("You have not subscribed to any feeds yet"),
      );
    }
    return FutureBuilder(
        future: APIService.getFeedContent(
            "${userFeeds?.feeds![feedIndex ?? 0].feedLink}"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var feedContent = snapshot.data;
            if (feedContent == null) {
              return const Center(child: Text("No content"));
            } else {
              return GridView.count(
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 2,
                // Generate 100 widgets that display their index in the List.
                children:
                    List.generate(feedContent.items?.length ?? 0, (index) {
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(children: [
                      ListTile(
                        // leading: Image.network(
                        //     "${userFeeds?.feeds![feedIndex ?? 0].imageLink}"),
                        leading: const Icon(Icons.feed_rounded),
                        title: Text("${feedContent.items![index].title}"),
                        subtitle: Text(
                          "${feedContent.items![index].author}",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "${feedContent.items![index].description}",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                    ]),
                  );
                }),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget feeds(UserFeeds? userFeeds) {
    if (userFeeds == null) {
      return const Center(
          child: Text("You have not subscribed to any feed yet"));
    }
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: userFeeds.feeds?.length,
        itemBuilder: (BuildContext context, int index) {
          // if (feeds[index].imageLink != null) {
          //   return Card(
          //     child: ListTile(
          //       leading: Image.network(feeds[index].imageLink ?? ""),
          //     ),
          //   );
          // } else {
          Color tileColor =
              index == feedIndex ? const Color(0xFF283B71) : Colors.white;
          return Card(
            child: ListTile(
              leading: const Icon(Icons.feed),
              title: Text(userFeeds.feeds![index].name),
              subtitle: Text("${userFeeds.feeds![index].imageLink}"),
              tileColor: tileColor,
              onTap: () => setState(() {
                feedIndex = index;
              }),
            ),
          );
          // }
        });
    // return FutureBuilder<UserFeeds>(
    //     future: userFeeds,
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         var feeds = snapshot.data?.feeds;
    //         if (feeds == null || feeds.length == 0) {
    //           return const Center(
    //             child: Text('No user feeds selected'),
    //           );
    //         }
    //         return ListView.builder(
    //             padding: const EdgeInsets.all(8),
    //             itemCount: feeds.length,
    //             itemBuilder: (BuildContext context, int index) {
    //               // if (feeds[index].imageLink != null) {
    //               //   return Card(
    //               //     child: ListTile(
    //               //       leading: Image.network(feeds[index].imageLink ?? ""),
    //               //     ),
    //               //   );
    //               // } else {
    //               return Card(
    //                 child: ListTile(
    //                   leading: Icon(Icons.feed),
    //                   title: Text(feeds[index].name),
    //                   subtitle: Text("${feeds[index].imageLink}"),
    //                 ),
    //               );
    //               // }
    //             });
    //       } else if (snapshot.hasError) {
    //         return Center(
    //           child: Text('${snapshot.error}'),
    //         );
    //       }

    //       return const CircularProgressIndicator();
    //     });
  }
}
