import 'package:flutter/material.dart';

import '../models/chat.dart';

class Chats extends ChangeNotifier {
  // ignore: prefer_final_fields
  List<Chat> _messages = [
    Chat(
        chatRoomId: '123',
        message: "I'm fine too",
        time: "6:30",
        receiverId: "ab",
        senderId: "cd"),
    Chat(
        chatRoomId: '123',
        message: "What about you",
        time: "6:00",
        receiverId: "cd",
        senderId: "ab"),
    Chat(
        chatRoomId: '123',
        message: "Im fine",
        time: "5:50",
        receiverId: "ab",
        senderId: "cd"),
    Chat(
        chatRoomId: '123',
        message: "How are you'",
        time: "5:45",
        receiverId: "cd",
        senderId: "ab"),
    Chat(
        chatRoomId: '123',
        message: "Hey",
        time: "5:30",
        receiverId: "ab",
        senderId: "cd"),
  ];

  List<Chat> get messages {
    return [..._messages];
  }

  List<Chat> fetchMessages() {
    return messages;
  }
}
