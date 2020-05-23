import 'package:flutter/material.dart';
import 'package:speackme/model/Message.dart';
import 'package:speackme/model/User.dart';
import 'package:speackme/widget/CustumImage.dart';

class ChatBubble extends StatelessWidget {
  Message message;
  User partenaire;
  String monId;
  Animation animation;

  ChatBubble(String id,User partenaire,Message message,Animation animation){
    this.monId=id;
    this.partenaire=partenaire;
    this.message=message;
    this.animation=animation;
  }

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
        sizeFactor: new CurvedAnimation(parent: animation, curve: Curves.easeIn),
      child: new Container(
        margin:EdgeInsets.all(10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: widgetsBubble(message.from ==monId),
        ),
      ),
    );
  }

  //Méthode qui retourne une liste de widget
  List<Widget>widgetsBubble(bool moi){
    CrossAxisAlignment alignment= (moi)? CrossAxisAlignment.end : CrossAxisAlignment.start;
    Color bubbleColor =(moi)? Colors.pink[100] : Colors.blue[400];
    Color textColor= (moi)? Colors.black : Colors.grey[200];

    return <Widget> [
      moi ? new Padding(padding: EdgeInsets.all(8.0)) :
         new CustumImage(partenaire.imageUrl,partenaire.initiales,15.0),
      new Expanded(
          child: new Column(
            crossAxisAlignment: alignment,
            children: <Widget>[
                new Text(message.dateString),
                new Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  color: bubbleColor,
                  child: new Container(
                    padding: EdgeInsets.all(5.0),
                    child: (message.imageUrl ==null)
                      ?  new Text(message.text ?? "",
                      style: TextStyle(color: textColor,fontSize:15.0,
                      fontStyle: FontStyle.italic),
                    )
                        : new CustumImage(message.imageUrl,null,null)
                  ),
                )
            ],
       ))
    ];
  }//fin widgetsBubble


}
