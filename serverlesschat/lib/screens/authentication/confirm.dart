import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:serverlesschat/screens/home.dart';

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
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      }
    } on AuthException catch (e) {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
    print('..............Confirm Page Rendered..............');
    final signupData =
        ModalRoute.of(context)?.settings.arguments as SignupData?;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 20),
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
                        SizedBox(
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
                          child: Text(
                            'Verify',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        MaterialButton(
                          elevation: 4,
                          onPressed: () {
                            _resendCode(context, signupData!);
                          },
                          child: Text(
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
