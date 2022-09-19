import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/users.dart';

// ignore: use_key_in_widget_constructors
class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    log('Profile Page Runs');
    final nameController = TextEditingController(
        text: Provider.of<Users>(context).loggedInUser!.name);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: Column(children: [
        Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(2),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Full Name',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10),
                    ),
                    controller: nameController,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Provider.of<Users>(context, listen: false)
                        .updateUserInformation(nameController.text);
                  },
                  icon: const Icon(Icons.save),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            )),
        Expanded(
          child: Container(),
        )
      ]),
    );
  }
}
