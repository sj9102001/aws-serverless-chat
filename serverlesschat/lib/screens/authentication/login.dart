import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:serverlesschat/screens/authentication/confirm-reset.dart';
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
      print('Logged in sucessfully');
    } on AuthException catch (e) {
      print('Error logging in');
      return e.message;
    }
    // await Amplify.Auth.signOut();
    return '';
  }

  Future<String> _onSignUp(SignupData data) async {
    try {
      final res = await Amplify.Auth.signUp(
        username: data.name!,
        password: data.password!,
        options: CognitoSignUpOptions(
          userAttributes: {CognitoUserAttributeKey.email: data.name!},
        ),
      );
      _data = data;
      print('Signed up succesfully');
      print(res);
    } on AuthException catch (e) {
      print('Error Signing up');
      print(e);
      return e.message;
    }
    return '';
  }

  Future<String?> _onRecoverPassword(BuildContext context, String email) async {
    try {
      final res = await Amplify.Auth.resetPassword(username: email);
      if (res.nextStep.updateStep == 'CONFIRM_RESET_PASSWORD_WITH_CODE') {
        Navigator.of(context).pushReplacementNamed(ConfirmResetScreen.routeName,
            arguments: LoginData(name: email, password: ''));
      }
      print('Recovering Password');
    } on AuthException catch (e) {
      print('Error Recovering Password');

      return e.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('..............Login Page Rendered..............');
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
