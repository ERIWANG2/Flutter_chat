import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:speackme/model/Message.dart';
import 'package:speackme/model/User.dart';
import 'package:speackme/widget/CustumImage.dart';
import 'package:speackme/widget/ZoneDeTexteWidget.dart';
import 'package:speackme/model/FirebaseHelper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:speackme/controller/MessageController.dart';
import 'package:speackme/widget/ChatBubble.dart';

class ChatController extends StatefulWidget {
  String id;
  User partenaire;

  ChatController(String id,User partenaire){
    this.id=id;
    this.partenaire=partenaire;
  }

  @override
  _ChatControllerState createState() => _ChatControllerState();
}

class _ChatControllerState extends State<ChatController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new CustumImage(widget.partenaire.imageUrl, widget.partenaire.initiales, 20.0),
          new Text(widget.partenaire.prenom)
        ],
      ),),
      body: Container(
        child: InkWell(
          onTap: ()=>FocusScope.of(context).requestFocus(new FocusNode()),
          child: Column(
            children: <Widget>[
              //zone de chat
              new Flexible(
                  child: new FirebaseAnimatedList(
                    query:FirebaseHelper().base_message.child(FirebaseHelper()
                        .getMessageRef(widget.id, widget.partenaire.id)),
                    reverse: true,
                    sort: (a,b)=>b.key.compareTo(a.key),
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double>animation,int index){
                          Message message=new Message(snapshot);
                          print(message.text);
                        return new ChatBubble(widget.id,widget.partenaire, message, animation);
                        //return new Container();
                    })
              ),
              //Divider
              new Divider(height: 1.5,),
              //zone de texte
              new ZoneDeTexteWidget(widget.partenaire,widget.id)
            ],
          ),
        ),
      ),
    );
  }
}
