import 'dart:convert';

import 'package:chat_app/Widgets/chat_user_card.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/chat_user.dart';


class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  List<UserModel> list = [];
  final List<UserModel> searchList = [];
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    final List<UserModel> chatUsers = [];

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () {
          if (isSearching) {
            setState(() {
              isSearching = !isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(

              centerTitle: true,
              leading: IconButton(
                onPressed: (){},
                icon: Icon(CupertinoIcons.home),
              ),
              title: isSearching? TextField(decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Name, Email...',

              ),
                autofocus: true,
                style: TextStyle(fontSize: 16,letterSpacing: 0.5),
                onChanged: (val){
                  searchList.clear();
                  for(var i in chatUsers){
                    if(i.name.contains(val)){
                      searchList.add(i);
                    }
                  }
                  setState(() {
                    searchList;
                  });
                }
                ,): Text('We Chat', style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary
              )),
              actions: [
                IconButton(onPressed: (){
                  setState(() {

                    isSearching=!isSearching;
                  });
                }, icon: Icon(isSearching? CupertinoIcons.clear_circled_solid: Icons.search)),
                IconButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> Profile(chatUsers[1])));
                }, icon: Icon(Icons.more_vert))
              ],
            ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  chatUsers.clear();
                  for (var i in data!) {
                    chatUsers.add(UserModel.fromJson(i.data()));
                  }
                  return ListView.builder(
                    itemCount: isSearching ? searchList.length : chatUsers.length, itemBuilder: (BuildContext context, int index) {


                    return ChatUserCard(isSearching? searchList[index]: chatUsers[index]);
                  },
                    // ... rest of your code ...
                  );

              }
            },
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: (){
              FirebaseAuth.instance.signOut();
            },
            child: Icon(Icons.add_comment),
          ),
          // ... rest of your code ...
        ),
      ),
    );
  }
}

