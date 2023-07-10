import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:flutter/material.dart';

import '../screens/chatScreen.dart';
class ChatUserCard extends StatefulWidget {
 const ChatUserCard(this.users,{super.key});
final UserModel users;
  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override

  Widget build(BuildContext context) {


    return Card(
      margin: EdgeInsets.only(top: 2, bottom: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 1,
      child: InkWell(
        onTap: (){
          print('chatCard ${widget.users.id}');
          Navigator.push(context, MaterialPageRoute(builder: (_)=>
            ChatScreen(user2: widget.users)
          ));

        },
        child: Expanded(
          child: ListTile(



            leading: CircleAvatar(

                backgroundImage: CachedNetworkImageProvider(
                  widget.users.image,)
            ),
            title: Text(widget.users.name),
            subtitle: Text(widget.users.about, maxLines: 1,),
            trailing: Text('12:00 PM', style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.primary
            )),

          ),
        )
      ),
    );
  }
}
