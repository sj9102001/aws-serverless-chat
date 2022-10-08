import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import '../../../providers/friends.dart';
import '../../../widgets/custom_list_tile.dart';

class FriendList extends StatelessWidget {
  const FriendList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<User> friendList =
        Provider.of<Friends>(context, listen: true).friendList;
    return ListView.builder(
      itemBuilder: ((context, index) => CustomListTile(
            name: friendList[index].name,
            email: friendList[index].email,
            userData: friendList[index],
            onTap: () {},
          )),
      itemCount: friendList.length,
    );
  }
}
