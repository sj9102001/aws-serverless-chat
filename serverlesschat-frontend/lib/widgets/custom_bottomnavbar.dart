import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomBottomNavigationBar extends StatefulWidget {
  Function onChangePageIndex;
  // ignore: use_key_in_widget_constructors
  CustomBottomNavigationBar({required this.onChangePageIndex});
  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      selectedItemColor: Theme.of(context).indicatorColor,
      unselectedItemColor: Theme.of(context).highlightColor,
      currentIndex: currentIndex,
      onTap: (index) {
        widget.onChangePageIndex(index);
        setState(() {
          currentIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group_add),
          label: 'Add friend',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: 'Profile',
        ),
      ],
    );
  }
}
