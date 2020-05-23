import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'controller/LoginController.dart';
import 'controller/MainAppController.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _handleAuth(),
    );
  }

  Widget _handleAuth(){
    return new StreamBuilder<FirebaseUser>(
        stream:FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context,snapshot){
          if(snapshot.hasData){
            //on est authentifié
            return new MainAppController();
          }else{
            //on est pas authentifié
            return new LoginController();
          }//fin if
        }
    );
  }//fin _handleAuth
}

