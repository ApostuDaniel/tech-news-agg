import 'package:flutter/material.dart';
import 'package:frontend_tech_news_agg/models/jwt_payload_model.dart';
import 'package:frontend_tech_news_agg/models/user_feed_model.dart';
import '../services/api_service.dart';
import '../services/shared_service.dart';

class AvailableFeedsPage extends StatefulWidget {
  const AvailableFeedsPage({Key? key}) : super(key: key);

  @override
  _AvailableFeedsPageState createState() => _AvailableFeedsPageState();
}

class _AvailableFeedsPageState extends State<AvailableFeedsPage> {
  late Future<UserFeeds> _userFeeds;
  late Future<List<Feed>> _allFeeds;
  // late Future<FeedContentModel> feedContent;
  late Future<JwtPayload?> _payload;

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
        future: Future.wait([_payload, _userFeeds, _allFeeds]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            var payload = cast<JwtPayload>(snapshot.data![0]);
            var userFeeds = cast<UserFeeds>(snapshot.data![1]);
            var allFeeds = cast<List<Feed>>(snapshot.data![2]);

            allFeeds?.removeWhere(
              (element) => userFeeds?.feeds?.contains(element) ?? false,
            );
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
              body: displayAvailableFeeds(allFeeds, userFeeds),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }

          return const CircularProgressIndicator();
        });
  }

  Widget displayAvailableFeeds(List<Feed>? feeds, UserFeeds? userFeeds) {
    if (feeds == null) {
      return const Center(
        child: Text("No more feeds available"),
      );
    }

    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: feeds.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.feed),
                title: Text(feeds[index].name),
                subtitle: Text("${feeds[index].imageLink}"),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () async {
                      if (userFeeds != null) {
                        userFeeds.feeds?.add(feeds[index]);
                        await APIService.updatedUserFeeds(userFeeds);
                        setState(() {});
                      }
                    },
                    child: const Text('Add to my feeds'),
                  ),
                ],
              ),
            ],
          ));
        });
  }
}
