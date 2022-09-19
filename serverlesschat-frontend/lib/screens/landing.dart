import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:serverlesschat/screens/home.dart';
import 'package:serverlesschat/screens/authentication/login.dart';

// ignore: use_key_in_widget_constructors
class LandingPage extends StatefulWidget {
  static const routeName = '/landing';

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _isAuthenticated = false;
  @override
  // ignore: must_call_super
  void initState() {
    _getUser();
  }

  void _getUser() async {
    try {
      await Amplify.Auth.getCurrentUser();
      setState(() {
        _isAuthenticated = true;
      });
    } on AuthException catch (_) {
      _isAuthenticated = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isAuthenticated ? HomeScreen() : const Login();
  }
}
