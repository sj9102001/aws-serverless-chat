import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:serverlesschat/screens/authentication/confirm_reset.dart';
import 'package:serverlesschat/screens/authentication/confirm.dart';
import 'package:serverlesschat/screens/home.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isSignedIn = false;
  SignupData? _data;

  Future<String> _onLogin(LoginData data) async {
    try {
      final res = await Amplify.Auth.signIn(
          username: data.name, password: data.password);

      _isSignedIn = res.isSignedIn;
      log('Logged in sucessfully');
    } on AuthException catch (e) {
      log('Error logging in');
      return e.message;
    }
    // await Amplify.Auth.signOut();
    return '';
  }

  Future<String> _onSignUp(SignupData data) async {
    try {
      await Amplify.Auth.signUp(
        username: data.name!,
        password: data.password!,
        options: CognitoSignUpOptions(
          userAttributes: {CognitoUserAttributeKey.email: data.name!},
        ),
      );
      _data = data;
      log('Signed up succesfully');
    } on AuthException catch (e) {
      log('Error Signing up');
      return e.message;
    }
    return '';
  }

  // ignore: body_might_complete_normally_nullable
  Future<String?> _onRecoverPassword(BuildContext context, String email) async {
    try {
      final res = await Amplify.Auth.resetPassword(username: email);
      if (res.nextStep.updateStep == 'CONFIRM_RESET_PASSWORD_WITH_CODE') {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacementNamed(ConfirmResetScreen.routeName,
            arguments: LoginData(name: email, password: ''));
      }
      log('Recovering Password');
    } on AuthException catch (e) {
      log('Error Recovering Password');

      return e.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    log('..............Login Page Rendered..............');
    return FlutterLogin(
      title: 'Serverless Chat',
      onLogin: (LoginData data) => _onLogin(data),
      onRecoverPassword: (String emailId) =>
          _onRecoverPassword(context, emailId),
      onSignup: (SignupData data) => _onSignUp(data),
      onSubmitAnimationCompleted: () {
        if (_isSignedIn) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        } else {
          Navigator.of(context)
              .pushReplacementNamed(ConfirmScreen.routeName, arguments: _data);
        }
      },
      theme: LoginTheme(primaryColor: Theme.of(context).primaryColor),
    );
  }
}
