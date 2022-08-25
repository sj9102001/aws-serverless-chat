import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import '/screens/login.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthUser? _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Amplify.Auth.getCurrentUser().then((user) {
      setState(() {
        _user = user;
      });
      print('Fetching Loggedin User');
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('..............Home Page Rendered..............');

    return Scaffold(
      appBar: AppBar(title: Text('Home'), actions: [
        MaterialButton(
          onPressed: () {
            Amplify.Auth.signOut().then((_) {
              Navigator.of(context).pushReplacementNamed(Login.routeName);
            });
            print('1');
          },
          child: Icon(
            Icons.logout,
            color: Colors.white,
          ),
        )
      ]),
      body: Center(
        child: _user == null ? Text('No User') : Text(_user!.userId),
      ),
    );
  }
}
