import 'dart:convert';
import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/models/user.dart';

class Friends extends ChangeNotifier {
  List<User> _friendList = [];
  List<User> _sentList = [];
  List<User> _receivedList = [];

  List<User> get friendList {
    return [..._friendList];
  }

  List<User> get sentList {
    return [..._sentList];
  }

  List<User> get receivedList {
    return [..._receivedList];
  }

  Future<String> sendFriendRequest(User userData) async {
    try {
      //imp
      final userInfo = await Amplify.Auth.getCurrentUser();
      final url = Uri.parse(
          'https://lvj1vr6se3.execute-api.us-east-1.amazonaws.com/test/send-friend-request');
      log('Making API Call - /send-friend-request');
      final response = await http.post(
        url,
        body: json.encode(
          {"sentBy": userInfo.userId, "sentTo": userData.userId},
        ),
      );
      final data = json.decode(response.body);
      if (data["Response"] != "Friend request is already sent to the user") {
        _sentList.add(
          User(
              userId: userData.userId,
              email: userData.email,
              bio: userData.bio,
              name: userData.name),
        );
        notifyListeners();
      }
      return data["Response"];
    } catch (e) {
      throw Exception('Error sending friend request');
    }
  }

  Future<String> acceptFriendRequest(User userData) async {
    try {
      //imp
      final userInfo = await Amplify.Auth.getCurrentUser();
      final url = Uri.parse(
          'https://lvj1vr6se3.execute-api.us-east-1.amazonaws.com/test/accept-friend-request');
      log('Making API Call - /accept-friend-request');
      final response = await http.post(
        url,
        body: json.encode(
          {"user": userInfo.userId, "acceptedUser": userData.userId},
        ),
      );
      final data = json.decode(response.body);
      if (response.statusCode == 400) {
        throw data['Response'];
      } else {
        _friendList.add(User(
            name: userData.name,
            email: userData.email,
            userId: userData.userId,
            bio: userData.bio));

        _receivedList.remove(userData);

        notifyListeners();
      }
      return data['Response'];
    } catch (e) {
      throw Exception('Error sending friend request');
    }
  }

  Future<void> fetchFriendsInformation() async {
    try {
      final currentUserInfo = await Amplify.Auth.getCurrentUser();
      final url = Uri.parse(
          'https://lvj1vr6se3.execute-api.us-east-1.amazonaws.com/test/fetch-friends');
      log('Making API Call - /fetch-users');
      final response = await http.post(url,
          body: json.encode({"UserId": currentUserInfo.userId}));
      final data = json.decode(response.body)["Response"];
      final friendListData = data["FriendList"];
      final sentListData = data["SentRequests"];
      final receivedListData = data["ReceivedRequests"];

      List<User> tempFriendListData = [];
      List<User> tempSentListData = [];
      List<User> tempReceivedListData = [];

      friendListData.forEach((currItem) {
        tempFriendListData.add(User(
            email: currItem["Email"],
            userId: currItem["UserId"],
            bio: currItem["Bio"],
            name: currItem["Name"]));
      });

      sentListData.forEach((currItem) {
        tempSentListData.add(User(
            email: currItem["Email"],
            userId: currItem["UserId"],
            bio: currItem["Bio"],
            name: currItem["Name"]));
      });
      receivedListData.forEach((currItem) {
        tempReceivedListData.add(User(
            email: currItem["Email"],
            userId: currItem["UserId"],
            bio: currItem["Bio"],
            name: currItem["Name"]));
      });
      _friendList = tempFriendListData;
      _sentList = tempSentListData;
      _receivedList = tempReceivedListData;
      notifyListeners();
    } catch (e) {
      log(e.toString(), level: 2000);
      rethrow;
    }
  }
}
