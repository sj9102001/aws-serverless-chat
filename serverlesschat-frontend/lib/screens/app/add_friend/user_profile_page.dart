import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import '../../../providers/friends.dart';
import '../../../widgets/profile_widget.dart';

class UserProfilePage extends StatefulWidget {
  static const routeName = '/user-profile';

  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _isLoading = false;
  Future<void> sendFriendRequest(
      BuildContext ctx, Friends friendsProvider, User userData) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await friendsProvider.sendFriendRequest(userData);
      // ignore: use_build_context_synchronously
      _showMessage(ctx, response, true);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      _showMessage(ctx, 'Sending friend request failed', false);
    }
  }

  Future<void> acceptFriendRequest(
      BuildContext ctx, Friends friendsProvider, User userData) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await friendsProvider.acceptFriendRequest(userData);
      // ignore: use_build_context_synchronously
      _showMessage(ctx, response, true);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      _showMessage(ctx, 'Sending friend request failed', false);
    }
  }

  void _showMessage(
      BuildContext context, String contentText, bool success) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(contentText),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    User userDetail = args['userDetail'];
    bool showAcceptFriendButton = args['showAcceptFriendButton'];
    Friends friendsProvider = Provider.of<Friends>(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(userDetail.name != null
              ? (userDetail.name!.isNotEmpty
                  ? userDetail.name!
                  : userDetail.email)
              : userDetail.email)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Profile(
              userData: userDetail,
              isLoggedInUserProfile: false,
              isLoading: _isLoading,
              onPressedHandler: () => showAcceptFriendButton
                  ? acceptFriendRequest(context, friendsProvider, userDetail)
                  : sendFriendRequest(context, friendsProvider, userDetail),
              showAcceptFriendButton: showAcceptFriendButton,
            )
          ],
        ),
      ),
    );
  }
}
