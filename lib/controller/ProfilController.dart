import 'package:flutter/material.dart';
import 'package:speackme/model/FirebaseHelper.dart';
import 'package:speackme/model/User.dart';
import 'package:speackme/widget/CustumImage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class ProfilController extends StatefulWidget {
  String id;

  ProfilController(String id) {
    this.id = id;
  }

  @override
  _ProfilControllerState createState() => _ProfilControllerState();
}

class _ProfilControllerState extends State<ProfilController> {
  User user;
  String prenom;
  String nom;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return (user == null)
        ? Center(
            child: Text(
            'Chargement...',
            style: TextStyle(fontSize: 22, color: Colors.blue),
          ))
        : SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new CustumImage(user.imageUrl,user.initiales,
              MediaQuery.of(context).size.width/5),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new IconButton(
                      icon: new Icon(Icons.camera_enhance),
                      onPressed: (){
                        _takePicture(ImageSource.camera);
                      }),
                   new IconButton(
                       icon: new Icon(Icons.photo_library),
                         onPressed: (){
                         _takePicture(ImageSource.gallery);
                         })
                ],
              ),
            
              TextField(
                  decoration: new InputDecoration(hintText: user.prenom),
                  onChanged: (String){
                    setState(() {
                      prenom=String;
                    });
                  },
              ),
              TextField(
                decoration: new InputDecoration(hintText: user.nom),
                onChanged: (String){
                  setState(() {
                    nom=String;
                  });
                },
              ),

              new RaisedButton(
                color: Colors.blue,
                  onPressed: _saveChanges,
                child: Text('Sauvegarder',
                  style: TextStyle(
                      fontSize: 20,color:Colors.white
                  ),
                ),
              ),

              new FlatButton(
                  onPressed: (){
                    _logOut(context);
                  },
                  child: Text('se déconnecter',
                    style: TextStyle(color: Colors.blue,fontSize: 20),
                  )
              )

            ],
          ),
        ),
    );
  }
  //méthode saveChanges
  _saveChanges(){
    //convertir l'utilisateur encours en Map
    Map map=user.toMap();
    //test si le contenu de la varibale prénom ou le nom a changé
    if(prenom !=null && prenom !=""){
      map["prenom"]=prenom;
    }
    if(nom !=null && nom !=""){
      map["nom"]=nom;
    }
    //ajout de la modification au niveau du firebase
    FirebaseHelper().addUser(user.id, map);
    -_getUser();
  }

  //Deconnexion
  Future<void>_logOut(BuildContext context)async{
    Text title=new Text("Se déconnecter");
    Text subtitle=new Text("Etes-vous sûr?");

    return showDialog(
        context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
          return (Theme.of(context).platform==TargetPlatform.iOS)
              ? new CupertinoAlertDialog(title:title,content:subtitle,actions:_actions(context),)
              :AlertDialog(title: title,content: subtitle,actions: _actions(context),);
      }
    );
  }

  List<Widget>_actions(BuildContext context){
    List<Widget>widgets=[];

    widgets.add(
        FlatButton(
            onPressed: (){
              FirebaseHelper().handleLogOut().then((bool){
                Navigator.of(context).pop();
              });
            },
            child: Text("OUI")));
    widgets.add(
        FlatButton(
            onPressed:()=>Navigator.of(context).pop(),
            child: Text("NON")));

    return widgets;
  }

  Future<void> _takePicture(ImageSource source)async{
    File image =await ImagePicker.pickImage(source: source,
        maxWidth: 500.0,maxHeight: 500.0);
    //obtenir une url après avoir ajouter l'image dans le stockage
    FirebaseHelper().savePicture(image,
        FirebaseHelper().storage_users.child(widget.id)).then((string){
        Map map=user.toMap();
        map["imageUrl"]=string;
        FirebaseHelper().addUser(user.id, map);
        _getUser();
    });
  }

  //méthode getuser
  _getUser() {
    FirebaseHelper().getUser(widget.id).then((user) {
      setState(() {
        this.user = user;
        print(user.nom+" "+user.prenom);
      });
    }); //fin FirebaseHelper
  } //fin _getUser

}
