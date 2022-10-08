import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_login/flutter_login.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../screens/home.dart';

// ignore: use_key_in_widget_constructors
class ConfirmScreen extends StatefulWidget {
  static const routeName = '/confirm';
  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  final _controller = TextEditingController();
  bool _isEnabled = false;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isEnabled = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  void _verifyCode(BuildContext context, SignupData? data, String code) async {
    try {
      final res = await Amplify.Auth.confirmSignUp(
          username: data!.name!, confirmationCode: code);
      if (res.isSignUpComplete) {
        await Amplify.Auth.signIn(
            username: data.name!, password: data.password!);
        final currentUser = await Amplify.Auth.getCurrentUser();
        //todo:
        //add user to dynamoDB
        final uri = Uri.parse(
            'https://lvj1vr6se3.execute-api.us-east-1.amazonaws.com/test/add-user');
        final userToDBResponse = await http.post(
          uri,
          body: json.encode(
            {"UserId": currentUser.userId, "Email": data.name},
          ),
        );

        // ignore: avoid_print
        print(userToDBResponse);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      }
    } on AuthException catch (e) {
      // ignore: avoid_print
      print(e);
      _showError(context, e.message);
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

  void _resendCode(BuildContext context, SignupData data) async {
    try {
      await Amplify.Auth.resendSignUpCode(username: data.name!);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Confirmation Code Resent.'),
          backgroundColor: Colors.blueAccent,
        ),
      );
    } on AuthException catch (e) {
      _showError(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    log('..............Confirm Page Rendered..............');
    final signupData =
        ModalRoute.of(context)?.settings.arguments as SignupData?;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 12,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  margin: const EdgeInsets.all(30),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 4),
                            prefixIcon: Icon(Icons.lock),
                            labelText: 'Enter Confirmation Code',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MaterialButton(
                          elevation: 4,
                          color: Theme.of(context).primaryColor,
                          onPressed: _isEnabled
                              ? () {
                                  _verifyCode(
                                      context, signupData, _controller.text);
                                }
                              : null,
                          disabledColor: Colors.deepPurple.shade100,
                          child: const Text(
                            'Verify',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        MaterialButton(
                          elevation: 4,
                          onPressed: () {
                            _resendCode(context, signupData!);
                          },
                          child: const Text(
                            'Resend Code',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
