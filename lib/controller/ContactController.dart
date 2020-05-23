import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:speackme/model/FirebaseHelper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:speackme/model/User.dart';
import 'package:speackme/widget/CustumImage.dart';
import 'package:speackme/controller/ChatController.dart';

class ContactController extends StatefulWidget {
  String id;

  ContactController(String id) {
    this.id = id;
  }

  @override
  _ContactControllerState createState() => _ContactControllerState();
}

class _ContactControllerState extends State<ContactController> {
  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
        query: FirebaseHelper().base_user,
        sort: (a, b) => a.value["prenom"]
            .toLowerCase()
            .compareTo(b.value["prenom"].toLowerCase()),
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          //récupéré un utilisateur
          User newUser = new User(snapshot);
          if (newUser.id == widget.id) {
            //retournons un container vide
            return Container();
          } else {
            return ListTile(
              leading:
                  new CustumImage(newUser.imageUrl, newUser.initiales, 20.0),
              title: Text("${newUser.prenom} ${newUser.nom}"),
              trailing: IconButton(
                  icon: new Icon(Icons.message),
                  onPressed: () {
                    //envoie vers le controller de chat pour discuter
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                new ChatController(widget.id, newUser)));
                  }),
            );
          } //fin if
        }); //fin FirebaseAnimate
  }
}
