import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:speackme/model/FirebaseHelper.dart';
import 'package:speackme/model/Conversation.dart';
import 'package:speackme/widget/CustumImage.dart';
import 'package:speackme/controller/ChatController.dart';

class MessageController extends StatefulWidget {
  String id;

  MessageController(String id){
    this.id=id;
  }

  @override
  _MessageControllerState createState() => _MessageControllerState();
}

class _MessageControllerState extends State<MessageController> {
  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
        query:FirebaseHelper().base_conversation.child(widget.id),
        sort: (a,b)=>a.value["dateString"].compareTo(b.value["dateString"]),
        itemBuilder:(BuildContext context, DataSnapshot snapshot,Animation<double> animation,int index){
            //création objet conversation
          Conversation conversation=new Conversation(snapshot);
          String subtitle=(conversation.id==widget.id)? "Moi: " : "";
          subtitle +=conversation.last_message ?? "image envoyée";
          return new ListTile(
            leading: new CustumImage(conversation.user.imageUrl,conversation.user.initiales,20.0),
            title: new Text("${conversation.user.prenom}  ${conversation.user.nom}"),
            subtitle: new Text(subtitle),
            trailing: new Text("${conversation.date}"),
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder:
                  (context)=>ChatController(widget.id,conversation.user)
                 )
              );
            },
          );

        });
  }
}
