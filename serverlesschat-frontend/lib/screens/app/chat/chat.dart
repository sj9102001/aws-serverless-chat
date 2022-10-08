import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/chat.dart';
import '../../../models/user.dart';

import '../../../providers/chats.dart';
import '../../../providers/websocket_provider.dart';

// ignore: use_key_in_widget_constructors
class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  void sendMessage(
    WebsocketProvider wsProvider,
    String text,
    String receiverId,
  ) {
    wsProvider.chatMessageWs(
      Chat(
        receiverId: receiverId,
        chatRoomId: '1234',
        message: text,
        senderId: 'ab',
        time: DateTime.now().toIso8601String(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentChatUser = ModalRoute.of(context)!.settings.arguments as User;
    final messages = Provider.of<Chats>(context).messages;
    final wsProvider = Provider.of<WebsocketProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          currentChatUser.name == null
              ? currentChatUser.email
              : currentChatUser.name.toString(),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    reverse: true,
                    padding: const EdgeInsets.only(top: 15),
                    itemBuilder: (context, index) {
                      String message = messages[index].message;
                      bool isMe =
                          messages[index].senderId == 'ab' ? true : false;
                      String time = messages[index].time;
                      return _buildMessage(context, message, isMe, time);
                    },
                    itemCount: messages.length,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              height: 70,
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration.collapsed(
                          hintText: 'Send a message....'),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      sendMessage(
                        wsProvider,
                        _messageController.value.text,
                        currentChatUser.userId,
                      );
                      setState(() {
                        _messageController.clear();
                      });
                    },
                    icon: const Icon(Icons.send),
                    iconSize: 25,
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Container _buildMessageField() {
  //   return ;
  // }
}

Widget _buildMessage(BuildContext ctx, String message, bool isMe, String time) {
  return Container(
    margin: isMe
        ? const EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: 80,
          )
        : const EdgeInsets.only(
            top: 8,
            bottom: 8,
            right: 80,
          ),
    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
    alignment: isMe ? Alignment.bottomRight : Alignment.bottomLeft,
    decoration: BoxDecoration(
        color: isMe ? Colors.deepPurple.shade300 : Colors.grey.shade300,
        borderRadius: isMe
            ? const BorderRadius.only(
                topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))
            : const BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15))),
    child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            message,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ]),
  );
}
// final messages = [
  //   {'isMe': false, 'time': '6:30', 'text': 'Im fine too'},
  //   {'isMe': true, 'time': '6:00', 'text': 'What about you'},
  //   {'isMe': true, 'time': '5:50', 'text': 'Im fine'},
  //   {'isMe': false, 'time': '5:45', 'text': 'How are you'},
  //   {'isMe': true, 'time': '5:30', 'text': 'Hey'},
  // ];
  // final messages = [];