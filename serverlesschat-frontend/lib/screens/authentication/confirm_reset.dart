import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_login/flutter_login.dart';

import '../../../screens/authentication/login.dart';

// ignore: use_key_in_widget_constructors
class ConfirmResetScreen extends StatefulWidget {
  static const routeName = '/confirm-reset';
  @override
  State<ConfirmResetScreen> createState() => ConfirmResetScreenState();
}

class ConfirmResetScreenState extends State<ConfirmResetScreen> {
  final _controller = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isEnabled = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isEnabled = _controller.text.isNotEmpty;
      });
    });
    _passwordController.addListener(() {
      setState(() {
        _isEnabled = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _passwordController.dispose();
  }

  void resetPassword(BuildContext context, LoginData data, String code,
      String password) async {
    try {
      await Amplify.Auth.confirmResetPassword(
          username: data.name, newPassword: password, confirmationCode: code);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Password changed successfully, please login!',
            style: TextStyle(fontSize: 15),
          ),
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacementNamed(Login.routeName);
    } on AuthException catch (e) {
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

  @override
  Widget build(BuildContext context) {
    log('..............Confirm Reset Page Rendered..............');
    final signupData = ModalRoute.of(context)?.settings.arguments as LoginData;
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
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            filled: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 4),
                            prefixIcon: const Icon(Icons.lock),
                            labelText: 'New Password',
                            suffixIcon: GestureDetector(
                              child: Icon(_obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            border: const OutlineInputBorder(
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
                                  resetPassword(
                                      context,
                                      signupData,
                                      _controller.text,
                                      _passwordController.text);
                                }
                              : null,
                          disabledColor: Colors.deepPurple.shade100,
                          child: const Text(
                            'Reset',
                            style: TextStyle(color: Colors.white, fontSize: 14),
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
