import 'package:flutter/material.dart';

class CustomTabItem extends StatelessWidget {
  String headline;

  CustomTabItem({required this.headline});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Text(
          headline,
          style: TextStyle(fontSize: 17),
        ),
      ),
    );
  }
}
