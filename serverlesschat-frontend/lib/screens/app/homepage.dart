import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import '../../../providers/friends.dart';
import '../../../screens/app/chat/chat.dart';
import '../../../widgets/custom_list_tile.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class HomePage extends StatelessWidget {
  List<User> userData = [];
  void _onTap(BuildContext ctx, User userData) {
    Navigator.of(ctx).pushNamed(ChatScreen.routeName, arguments: userData);
  }

  @override
  Widget build(BuildContext context) {
    userData = Provider.of<Friends>(context).friendList;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Home'),
        ),
        body: userData.isEmpty
            ? const Center(
                child: Text('No Users available'),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(5),
                itemBuilder: ((context, index) => Container(
                      decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide())),
                      child: CustomListTile(
                        email: userData[index].email,
                        name: userData[index].name,
                        userData: userData[index],
                        onTap: () => _onTap(context, userData[index]),
                      ),
                    )),
                itemCount: userData.length,
              ));
  }
}
