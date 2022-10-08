import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/users.dart';

import '../../../models/user.dart';

import '../../../screens/app/add_friend/friend_list.dart';
import '../../../screens/app/add_friend/received_list.dart';
import '../../../screens/app/add_friend/sent_list.dart';
import '../../../screens/app/add_friend/user_profile_page.dart';

import '../../../widgets/tabbar_item.dart';

class AddFriendPage extends StatelessWidget {
  const AddFriendPage({Key? key}) : super(key: key);

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
        body: const TabBarView(children: [
          Center(
            child: FriendList(),
          ),
          Center(
            child: SentList(),
          ),
          Center(
            child: ReceivedList(),
          ),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Provider.of<WebsocketProvider>(context, listen: false)
            // .chatMessageWs(Chat);
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.refresh),
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
        icon: const Icon(Icons.search),
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
    return Center(
      child: FutureBuilder(
        future: Provider.of<Users>(context, listen: false).searchUsers(query),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Text('User not found');
          } else if (snapshot.hasData == true) {
            List<User> searchedUsers = snapshot.data as List<User>;
            return ListView.builder(
              itemBuilder: ((context, index) => ListTile(
                    title: Text(searchedUsers[index].name != null &&
                            searchedUsers[index].name!.isNotEmpty
                        ? searchedUsers[index].name!
                        : searchedUsers[index].email),
                    onTap: () {
                      Navigator.of(context).pushNamed(UserProfilePage.routeName,
                          arguments: {
                            'userDetail': searchedUsers[index],
                            'showAcceptFriendButton': false
                          });
                    },
                  )),
              itemCount: searchedUsers.length,
            );
          } else {
            return const Text('User not found');
          }
        }),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(child: Text('Search'));
  }
}
