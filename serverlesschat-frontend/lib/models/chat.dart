class Chat {
  String chatRoomId;
  String senderId;
  String receiverId;
  String time;
  String message;

  Chat({
    required this.chatRoomId,
    required this.senderId,
    required this.message,
    required this.receiverId,
    required this.time,
  });
}
