import 'package:flutter/material.dart';

import '../models/user.dart';
import '../widgets/profile_image.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  User userData;
  bool isLoggedInUserProfile;
  VoidCallback onPressedHandler;
  bool? isLoading = false;
  bool showAcceptFriendButton = false;
  Profile(
      {Key? key,
      required this.userData,
      this.isLoading,
      required this.isLoggedInUserProfile,
      required this.onPressedHandler,
      required this.showAcceptFriendButton})
      : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    User user = widget.userData;
    return Center(
      child: Column(
        children: [
          Stack(children: [
            buildImage(user),
          ]),
          const SizedBox(
            height: 20,
          ),
          buildName(
              user.name != null
                  ? user.name!.isEmpty
                      ? ''
                      : user.name.toString()
                  : '',
              user.email),
          const SizedBox(
            height: 20,
          ),
          widget.isLoggedInUserProfile
              ? Container()
              : widget.isLoading == false
                  ? widget.showAcceptFriendButton
                      ? buildAcceptFriendButton(widget.onPressedHandler)
                      : buildAddToFriendButton(widget.onPressedHandler)
                  : const Center(child: CircularProgressIndicator()),
          const SizedBox(
            height: 40,
          ),
          buildAbout(user)
        ],
      ),
    );
  }
}

Widget buildCircle({
  required Widget child,
  required double all,
  required Color color,
}) =>
    ClipOval(
      child: Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ),
    );

Widget buildImage(User userData) {
  return ProfilePicture(
    size: 65,
    name: userData.name != null
        ? userData.name!.isEmpty
            ? userData.email.toString()
            : userData.name.toString()
        : userData.email.toString(),
  );
}

Widget buildAddToFriendButton(VoidCallback onPressedH) => ElevatedButton(
      onPressed: onPressedH,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
      child: const Text('Add to friend'),
    );

Widget buildAcceptFriendButton(VoidCallback onPressedH) => ElevatedButton(
      onPressed: onPressedH,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
      child: const Text('Accept friend request'),
    );

Widget buildName(String name, String email) => Column(
      children: [
        Text(
          // ignore: prefer_if_null_operators, unnecessary_null_comparison
          name == null ? '' : name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: const TextStyle(color: Colors.grey),
        )
      ],
    );

Widget buildAbout(User user) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            user.bio == null ? '' : user.bio!,
            style: const TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      ),
    );
