import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import '../../amplifyconfiguration.dart';

import 'screens/authentication/confirm-reset.dart';
import 'screens/home.dart';
import 'screens/authentication/login.dart';
import 'screens/authentication/confirm.dart';
import 'screens/landing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _amplifyConfigured = false;
  @override
  void initState() {
    _configureAmplify();
  }

  void _configureAmplify() async {
    try {
      final auth = AmplifyAuthCognito();
      final analytics = AmplifyAnalyticsPinpoint();
      await Amplify.addPlugin(auth);
      await Amplify.addPlugin(analytics);
      // call Amplify.configure to use the initialized categories in your app
      await Amplify.configure(amplifyconfig);
      setState(() {
        _amplifyConfigured = true;
      });
      print('Amplify successfully Configured');
    } on Exception catch (e) {
      print('An error occurred configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.deepPurple,
          appBarTheme: AppBarTheme(color: Colors.deepPurple)),
      home: Scaffold(
        body: Container(
          child: Center(
            child: _amplifyConfigured == true
                ? LandingPage()
                : const CircularProgressIndicator(),
          ),
        ),
      ),
      routes: {
        LandingPage.routeName: (ctx) => LandingPage(),
        Login.routeName: (ctx) => Login(),
        ConfirmScreen.routeName: (ctx) => ConfirmScreen(),
        ConfirmResetScreen.routeName: (ctx) => ConfirmResetScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen()
      },
    );
  }
}
