import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:provider/provider.dart';
import 'package:serverlesschat/providers/chats.dart';
import 'package:serverlesschat/providers/users.dart';
import 'package:serverlesschat/providers/websocket_provider.dart';
import 'package:serverlesschat/screens/app/chat/chat.dart';

import '../../amplifyconfiguration.dart';

import 'screens/authentication/confirm_reset.dart';
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
  // ignore: must_call_super
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
      log('Amplify successfully Configured');
    } on Exception catch (e) {
      log('An error occurred configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Users()),
        ChangeNotifierProvider(create: (ctx) => WebsocketProvider()),
        ChangeNotifierProvider(create: (ctx) => Chats()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.deepPurple,
            appBarTheme: const AppBarTheme(color: Colors.deepPurple),
            indicatorColor: Colors.white,
            highlightColor: Colors.black),
        home: Scaffold(
          body: Center(
            child: _amplifyConfigured == true
                ? LandingPage()
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
        routes: {
          LandingPage.routeName: (ctx) => LandingPage(),
          Login.routeName: (ctx) => const Login(),
          ConfirmScreen.routeName: (ctx) => ConfirmScreen(),
          ConfirmResetScreen.routeName: (ctx) => ConfirmResetScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          ChatScreen.routeName: (ctx) => ChatScreen()
        },
      ),
    );
  }
}
