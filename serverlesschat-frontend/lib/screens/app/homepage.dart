import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serverlesschat/models/user.dart';
import 'package:serverlesschat/providers/users.dart';
import 'package:serverlesschat/screens/app/chat.dart';
import 'package:serverlesschat/screens/authentication/login.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class HomePage extends StatelessWidget {
  List<User> userData = [];
  @override
  Widget build(BuildContext context) {
    userData = Provider.of<Users>(context).users;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Home'),
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
        body: userData.isEmpty
            ? const Center(
                child: Text('No Users available'),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(5),
                itemBuilder: ((context, index) => Container(
                      decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide())),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        tileColor: Colors.white,
                        leading: const CircleAvatar(
                          radius: 20,
                          child: Text('SJ'),
                        ),
                        title: Text(userData[index].name != null
                            ? userData[index].name.toString()
                            : userData[index].email.toString()),
                        subtitle: const Text('Latest message'),
                        onTap: () {
                          Navigator.of(context).pushNamed(ChatScreen.routeName,
                              arguments: userData[index]);
                        },
                      ),
                    )),
                itemCount: userData.length,
              ));
  }
}
