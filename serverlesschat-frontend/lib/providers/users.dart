import 'dart:convert';
import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class Users with ChangeNotifier {
  User? _loggedInUser;

  User? get loggedInUser {
    return _loggedInUser;
  }

  List<User> _users = [];

  List<User> get users {
    return [..._users];
  }

  Future<void> fetchCurrentUserDetails() async {
    try {
      final url = Uri.parse(
          'https://lvj1vr6se3.execute-api.us-east-1.amazonaws.com/test/user-details');
      log('Making API Call - /user-details');
      final currentUser = await Amplify.Auth.getCurrentUser();
      final currentUserId = currentUser.userId;
      final response =
          await http.post(url, body: json.encode({'UserId': currentUserId}));
      final data =
          json.decode(response.body)["Response"] as Map<String, dynamic>;

      if (!data.containsKey("Email") || !data.containsKey("UserId")) {
        throw Exception('Email or UserId is not available');
      }
      User user = User(
        email: data["Email"].toString(),
        userId: data["UserId"].toString(),
        name: data.containsKey("Name") ? data["Name"] : null,
      );
      _loggedInUser = user;
      notifyListeners();
    } catch (e) {
      log(e.toString(), level: 2000);
      rethrow;
    }
  }

  Future<void> updateUserInformation(String name) async {
    try {
      // final url = Uri.parse(
      // 'https://lvj1vr6se3.execute-api.us-east-1.amazonaws.com/test/update-user');
      // final response = await http.post(url,
      // body: json.encode({'UserId': _loggedInUser!.userId, 'Name': name}));
      _loggedInUser!.name = name;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAllUser() async {
    try {
      final url = Uri.parse(
          'https://lvj1vr6se3.execute-api.us-east-1.amazonaws.com/test/fetch-users');
      log('Making API Call - /fetch-users');
      final response = await http.get(url);
      final data = json.decode(response.body);
      List<User> userList = [];
      data.forEach((currUser) {
        userList.add(
          User(
              email: currUser['Email'],
              userId: currUser['UserId'],
              name: currUser['Name']),
        );
      });
      _users = userList;
      notifyListeners();
    } catch (e) {
      log(e.toString(), level: 2000);
      rethrow;
    }
  }
}
