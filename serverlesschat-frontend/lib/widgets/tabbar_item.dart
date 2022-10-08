import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTabItem extends StatelessWidget {
  String headline;

  CustomTabItem({Key? key, required this.headline}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Text(
          headline,
          style: const TextStyle(fontSize: 17),
        ),
      ),
    );
  }
}
