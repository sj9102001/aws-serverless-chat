import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import '../../../providers/friends.dart';
import '../../../screens/app/add_friend/user_profile_page.dart';
import '../../../widgets/custom_list_tile.dart';

class ReceivedList extends StatelessWidget {
  const ReceivedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<User> receivedList =
        Provider.of<Friends>(context, listen: true).receivedList;
    return receivedList.isEmpty
        ? const Center(
            child: Text('No friend request sent'),
          )
        : ListView.builder(
            itemBuilder: ((context, index) => CustomListTile(
                  name: receivedList[index].name,
                  email: receivedList[index].email,
                  userData: receivedList[index],
                  onTap: () {
                    Navigator.of(context).pushNamed(UserProfilePage.routeName,
                        arguments: {
                          'userDetail': receivedList[index],
                          'showAcceptFriendButton': true
                        });
                  },
                )),
            itemCount: receivedList.length,
          );
  }
}
