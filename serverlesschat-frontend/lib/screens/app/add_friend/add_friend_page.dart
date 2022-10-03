import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serverlesschat/models/user.dart';
import 'package:serverlesschat/providers/users.dart';
import 'package:serverlesschat/screens/app/add_friend/friend_list.dart';
import 'package:serverlesschat/screens/app/add_friend/received_list.dart';
import 'package:serverlesschat/screens/app/add_friend/sent_list.dart';
import 'package:serverlesschat/widgets/tabbar_item.dart';

class AddFriendPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Friend'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: MySearchDelegate());
              },
            )
          ],
          bottom: TabBar(
            tabs: [
              CustomTabItem(headline: 'Friends'),
              CustomTabItem(headline: 'Sent'),
              CustomTabItem(headline: 'Received')
            ],
          ),
        ),
        body: TabBarView(children: [
          Center(
            child: Text('FriendList'),
          ),
          Center(
            child: Text('SentList'),
          ),
          Center(
            child: Text('ReceivedList'),
          ),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Provider.of<WebsocketProvider>(context, listen: false)
            // .chatMessageWs(Chat);
          },
          child: const Icon(Icons.send),
        ),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            showResults(context);
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Users>(context, listen: false).searchUsers(query),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('User not found');
        } else if (snapshot.hasData == true) {
          List<User> searchedUsers = snapshot.data as List<User>;
          return ListView.builder(
            itemBuilder: ((context, index) => ListTile(
                  title: Text(searchedUsers[index].email),
                  onTap: () {},
                )),
            itemCount: searchedUsers.length,
          );
        } else {
          return Text('User not found');
        }
      }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
        child: Container(
      child: Text('Search'),
    ));
  }
}
