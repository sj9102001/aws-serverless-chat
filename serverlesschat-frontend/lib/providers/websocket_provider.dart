import 'package:flutter/cupertino.dart';
import 'package:cron/cron.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import '/models/chat.dart';

class WebsocketProvider with ChangeNotifier {
  WebSocket? socketChannel;
  bool isConnected = false;
  Cron? _cron;

  Future<void> connectToWs() async {
    Amplify.Auth.getCurrentUser().then((user) {
      String wssUrl =
          // "wss://.execute-api.us-east-1.amazonaws.com/dev?userId=${user.userId}";
          "wss://ws.postman-echo.com/raw";

      final connection = WebSocket.connect(wssUrl);
      connection.then((value) {
        socketChannel = value;
        isConnected = true;

        //Listening to Message
        socketChannel!.listen((event) {
          log(event);
        });

        //Ensure that connection is not closed due to inactivity
        log('connected to ws server');
        ensureConnected();

        notifyListeners(); //move this
      }).catchError((error) {
        isConnected = false;
        socketChannel = null;
        log(error.toString());
      });
    });
  }

  void sendEnsureMessage() {
    if (socketChannel != null) {
      socketChannel!.add('Message');
    } else {
      log('no socket connection');
    }
  }

  void chatMessageWs(Chat chatMessage) {
    if (socketChannel != null) {
      // socketChannel!.add(
      // "'action':'temp,'sentBy':'abcd','sentTo':'efgh','message':'how are you','sentAt':${DateTime.now().toIso8601String()}");

      socketChannel!.add(
        json.encode(
          {
            'action': 'temp',
            'sentBy': chatMessage.senderId,
            'sentTo': chatMessage.receiverId,
            'message': chatMessage.message,
            'sentAt': chatMessage.time
          },
        ),
      );
    } else {
      log('no socket connection');
    }
  }

  Future<void> closeWsConnection() async {
    if (socketChannel != null) {
      socketChannel!.close().then((_) {
        stopEnsureConnected();
        log('connection closed');
      }).catchError((_) {
        log('connection closing failed');
      });
    }
  }

  void ensureConnected() {
    _cron = Cron();
    _cron!.schedule(Schedule.parse('*/50 * * * * *'), () {
      sendEnsureMessage();

      log('Sent message to WS to keep connection');
    });
  }

  void stopEnsureConnected() {
    _cron!.close().then((_) {
      log('closed cron');
    }).catchError((e) {
      log(e.toString());
    });
  }
}
