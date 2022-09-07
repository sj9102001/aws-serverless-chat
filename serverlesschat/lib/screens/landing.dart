import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:serverlesschat/screens/home.dart';
import 'package:serverlesschat/screens/authentication/login.dart';

class LandingPage extends StatefulWidget {
  static const routeName = '/landing';

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _isAuthenticated = false;
  @override
  void initState() {
    // TODO: implement initState
    _getUser();
  }

  void _getUser() async {
    try {
      AuthUser _user = await Amplify.Auth.getCurrentUser();
      setState(() {
        _isAuthenticated = true;
      });
    } on AuthException catch (e) {
      _isAuthenticated = false;
      print('current user $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isAuthenticated ? HomeScreen() : Login();
  }
}
