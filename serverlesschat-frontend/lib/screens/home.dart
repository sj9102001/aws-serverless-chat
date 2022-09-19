import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serverlesschat/screens/app/homepage.dart';

import '../providers/users.dart';
import 'app/add_friend_page.dart';
import 'app/profile_page.dart';
import '../widgets/custom_bottomnavbar.dart';
import '../providers/websocket_provider.dart';

// ignore: use_key_in_widget_constructors
class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;
  WebsocketProvider? wsProvider;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<WebsocketProvider>(context, listen: false).connectToWs();
      Provider.of<Users>(context, listen: false).fetchAllUser().catchError((e) {
        log(e);
      });
      Provider.of<Users>(context, listen: false)
          .fetchCurrentUserDetails()
          .catchError((e) {
        log(e);
      });
    });
  }

  AuthUser? loggedInUser;

  @override
  void dispose() {
    super.dispose();
    wsProvider!.closeWsConnection();
  }

  void changeCurrentPageIndex(int newPageIndex) {
    setState(() {
      currentPageIndex = newPageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    wsProvider = Provider.of<WebsocketProvider>(context, listen: false);
    log('..............Home Page Rendered..............');
    return Scaffold(
        bottomNavigationBar: CustomBottomNavigationBar(
            onChangePageIndex: changeCurrentPageIndex),
        body: IndexedStack(
          index: currentPageIndex,
          children: [HomePage(), const AddFriendPage(), ProfilePage()],
        ));
  }
}
