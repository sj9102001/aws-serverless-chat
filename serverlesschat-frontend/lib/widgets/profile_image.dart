import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProfilePicture extends StatelessWidget {
  double size;
  String name;

  ProfilePicture({Key? key, required this.size, required this.name})
      : super(key: key);

  String getInitials(String userName) => userName.isNotEmpty
      ? userName.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join()
      : '';

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size,
      backgroundColor: Theme.of(context).primaryColor,
      child: Text(
        getInitials(name).toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
