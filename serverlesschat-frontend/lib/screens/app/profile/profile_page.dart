import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:provider/provider.dart';

import 'dart:developer';

import '../../../models/user.dart';

import '../../../providers/users.dart';

import '../../../screens/app/profile/edit_profile_page.dart';
import '../../../screens/authentication/login.dart';

import '../../../widgets/profile_widget.dart';

// ignore: use_key_in_widget_constructors
class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _signOut(BuildContext ctx) {
    Amplify.Auth.signOut().then((_) {
      Navigator.of(ctx).pushReplacementNamed(Login.routeName);
    });
  }

  void _viewEditPage(BuildContext ctx, User userData) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EditProfilePage(userData: userData)));
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<Users>(context);
    log('Profile Page Runs');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        actions: [
          IconButton(
            onPressed: () => _viewEditPage(context, userProvider.loggedInUser!),
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () => _signOut(context),
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(2),
            // null check operator used on a null value
            child: Profile(
              userData: userProvider.loggedInUser!,
              isLoggedInUserProfile: true,
              onPressedHandler: () {},
              showAcceptFriendButton: false,
            ),
          )
        ],
      ),
    );
  }
}
