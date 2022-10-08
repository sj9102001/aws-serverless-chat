import 'package:flutter/material.dart';

import '../models/user.dart';
import '../widgets/profile_image.dart';

// ignore: must_be_immutable
class CustomListTile extends StatelessWidget {
  String? name;
  String email;
  User userData;
  VoidCallback onTap;
  CustomListTile(
      {Key? key,
      required this.onTap,
      this.name,
      required this.email,
      required this.userData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(10),
      tileColor: Colors.white,
      leading: ProfilePicture(
        size: 20,
        name: name != null
            ? name!.isEmpty
                ? email.toString()
                : name.toString()
            : email.toString(),
      ),
      title: Text(name != null
          ? name!.isEmpty
              ? email.toString()
              : name.toString()
          : email.toString()),
      onTap: onTap,
    );
  }
}
