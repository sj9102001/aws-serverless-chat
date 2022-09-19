import 'package:flutter/material.dart';

class AddFriendPage extends StatelessWidget {
  const AddFriendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friend'),
      ),
      body: const Center(
        child: Text('Add Friend Here'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Provider.of<WebsocketProvider>(context, listen: false)
          // .chatMessageWs(Chat);
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}
