import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serverlesschat/screens/authentication/login.dart';

import '../../../providers/users.dart';

// ignore: use_key_in_widget_constructors
class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> updateUserInformation(Users userProvider, String name) async {
    try {
      await userProvider.updateUserInformation(name);
    } catch (e) {
      _showError(context, 'Update user failed');
    }
  }

  void _showError(BuildContext context, String contentText) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(contentText),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<Users>(context);
    log('Profile Page Runs');
    final nameController = TextEditingController(
        text: Provider.of<Users>(context).loggedInUser!.name);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        actions: [
          MaterialButton(
            onPressed: () {
              Amplify.Auth.signOut().then((_) {
                Navigator.of(context).pushReplacementNamed(Login.routeName);
              });
            },
            child: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
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
                  onPressed: () =>
                      updateUserInformation(userProvider, nameController.text),
                  icon: const Icon(Icons.save),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            )),
        Expanded(
          child: Container(),
        ),
      ]),
    );
  }
}
