import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Widgets/messageScreen.dart';
import 'package:chat_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_user.dart';
import '../models/chatmesaage.dart';

String? getCurrentUserId() {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid;
  }
  return null;
}

class ChatScreen extends StatefulWidget {
  ChatScreen({required this.user2, Key? key}) : super(key: key);

  final UserModel user2;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  late Stream<QuerySnapshot> messagesStream;




  @override
  void initState() {
    super.initState();

    final conversationID = getConversationID(widget.user2.id);
    final currentUserID = getCurrentUserId();

   messagesStream = FirebaseFirestore.instance
        .collection('chats/$conversationID/messages')
        .orderBy('sent', descending: true)
        .snapshots();
  }

    String getConversationID(String id) {
    final currentUserID = getCurrentUserId();
    if (currentUserID == null) {
      return '';
    }
    return currentUserID.hashCode <= id.hashCode
        ? '$currentUserID-$id'
        : '$id-$currentUserID';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: _appBar(),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children:  [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messagesStream,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final messageDocs = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messageDocs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot messageDoc = messageDocs[index];
                    ChatMessage message = ChatMessage.fromJson(messageDoc.data() as Map<String, dynamic>);

                    return MessageWidget(message);
                  },
                );
              },
            ),
          ),
          _chatInput(),
        ],

      ),
    ));
  }

  Widget _appBar() {
    return InkWell(
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.black54),
          ),
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(widget.user2.image),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user2.name,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Last seen not available',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),

              ],
            ),
          ),
          IconButton(onPressed: (){}, icon: Icon(Icons.work))
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Type Something....',
                        hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.image,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.camera,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              final currentUserID = getCurrentUserId();
              print('current user id $currentUserID');
              print('other user id ${widget.user2.id}');
              if (currentUserID != null) {
                FirebaseFirestore.instance
                    .collection('chats/${getConversationID(widget.user2.id)}/messages')
                    .add({
                  'msg': messageController.text,
                  'toId': widget.user2.id,
                  'read': '',
                  'type': Type.text.name,
                  'fromId': currentUserID,
                  'sent': DateTime.now(),
                });
              }
setState(() {

});
              messageController.clear();
            },
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            color: Colors.green,
            shape: CircleBorder(),
            child: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
