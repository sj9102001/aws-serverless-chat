import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import '../../../providers/friends.dart';
import '../../../widgets/custom_list_tile.dart';

class SentList extends StatelessWidget {
  const SentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<User> sentList = Provider.of<Friends>(context, listen: true).sentList;
    return sentList.isEmpty
        ? const Center(
            child: Text('No friend request sent'),
          )
        : ListView.builder(
            itemBuilder: ((context, index) => CustomListTile(
                  name: sentList[index].name,
                  email: sentList[index].email,
                  userData: sentList[index],
                  onTap: () {},
                )),
            itemCount: sentList.length,
          );
  }
}
