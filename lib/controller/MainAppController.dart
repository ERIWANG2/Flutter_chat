import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:speackme/model/FirebaseHelper.dart';
import 'package:speackme/controller/ContactController.dart';
import 'package:speackme/controller/MessageController.dart';
import 'package:speackme/controller/ProfilController.dart';
import 'package:flutter/cupertino.dart';


class MainAppController extends StatefulWidget {
  @override
  _MainAppControllerState createState() => _MainAppControllerState();
}

class _MainAppControllerState extends State<MainAppController> {
  String id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseHelper().myId().then((uid){
      setState(() {
        id=uid;
      });
    });//fin FirebaseHelper

  }//fin initstate

  @override
  Widget build(BuildContext context) {
    Text titre=new Text("SpeakMe");
    return FutureBuilder(
      future: FirebaseHelper().auth.currentUser(),
      builder: (BuildContext context,AsyncSnapshot<FirebaseUser>snapshot){
        if(snapshot.connectionState==ConnectionState.done){
          //choix du theme de l'application
          if(Theme.of(context).platform==TargetPlatform.iOS){
              //cas telephone ios on retourne widget de navigation bas
              return new CupertinoTabScaffold(
                  tabBar: CupertinoTabBar(
                      backgroundColor: Colors.blue,
                      activeColor: Colors.black,
                      inactiveColor: Colors.white,
                      items:[
                    new BottomNavigationBarItem(icon: new Icon(Icons.message),),
                    new BottomNavigationBarItem(icon: new Icon(Icons.supervisor_account),),
                    new BottomNavigationBarItem(icon: new Icon(Icons.account_circle),),
                  ]),
                  tabBuilder: (BuildContext context,int index){
                    Widget controllerSelected=controllers()[index];
                    return Scaffold(
                      appBar: AppBar(title: titre,),
                      body: controllerSelected,
                    );
                  } //fin tabBuilder
              );
          }else{
              //cas telephone Android on retourne widget avec onglet
              return DefaultTabController(
                length: 3,
                child: Scaffold(
                  appBar: AppBar(title: titre,
                    bottom: TabBar(tabs:[
                      new Tab(icon: new Icon(Icons.message),),
                      new Tab(icon: new Icon(Icons.supervisor_account),),
                      new Tab(icon: new Icon(Icons.account_circle),),
                    ],),
                  ),

                  body: TabBarView(
                    children:controllers(),
                  ),
                )
              );
          }//fin if choix theme
          
        }else{
          //encas d'absence de la connexion
          return Scaffold(
            appBar: AppBar(title: titre,),
            body: Text('Chargement...',
              style: TextStyle(fontSize: 22,color: Colors.blue),
            )
          );
        };// fin if connectionstate
      } //fin builder
    );
  } //fin Widget build

 //méthode controller
  List<Widget>controllers(){
    return [
      new MessageController(id),
      new ContactController(id),
      new ProfilController(id),
    ];
  }

}
