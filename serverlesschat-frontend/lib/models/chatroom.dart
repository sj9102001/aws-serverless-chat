import './chat.dart';

class ChatRoom {
  String? chatRoomId;
  String userOne;
  String userTwo;
  List<Chat>? messages;

  ChatRoom({this.messages, required this.userOne, required this.userTwo});
}
