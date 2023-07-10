

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/models/chatmesaage.dart';

class MessageWidget extends StatelessWidget {
  final ChatMessage message;

  MessageWidget(this.message, {Key? key}) : super(key: key);

  String? getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return getCurrentUserId() == message.fromId ? _greenMessage() : _blueMessage();
  }

  Widget _blueMessage() {
    return Row(
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white54,
              border: Border.all(color: Colors.blueAccent),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Text(
              message.msg,
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Text(
        //     message.sent,
        //   ),
        // ),
      ],
    );
  }

  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(width: 10),
        // Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),
        SizedBox(width: 10),
        Text(
          message.read.toString(),
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white54,
              border: Border.all(color: Colors.greenAccent),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Text(
              message.msg,
            ),
          ),
        ),
      ],
    );
  }

}
