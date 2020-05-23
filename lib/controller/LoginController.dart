import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:speackme/model/FirebaseHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends StatefulWidget {
  @override
  _LoginControllerState createState() => _LoginControllerState();
}

class _LoginControllerState extends State<LoginController> {
  //déclaration des variables
  bool log=true;
  String mail;
  String password;
  String prenom;
  String nom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Authentification')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20.0),
              width: MediaQuery.of(context).size.width-40,
              height: MediaQuery.of(context).size.height/2,
              child: Card(
                elevation: 8.5,
                child:Container(
                  margin: EdgeInsets.only(left: 5.0,right: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: cardElement(),
                  ),
                ),

              ),
            ),
            RaisedButton(
              onPressed: handlelog,
              //onPressed: seloger,
              color: Colors.blue,
              child: Text((log==true)?"Se connecter":"S'inscrire",
                style: TextStyle(color: Colors.white,fontSize: 22),
              ),
            )
          ],
        ),
      ),
    );
  }
//méthode handlelog
  handlelog(){
    if(mail !=null){
      if(password !=null){
        if(log==true){
          //se connecter
          FirebaseHelper().handleSingIn(mail, password)
              .then((FirebaseUser user){
                print("Nous avons un utilisateur");
          }).catchError((error){
            alert(error.toString());
          });
        }else{
          //log ==false . Donc on doit s'inscrire
          if(prenom !=null){
            if(nom !=null){
              //inscription
              FirebaseHelper().handleCreate(mail, password, prenom, nom)
                  .then((FirebaseUser user){
                 print("Nous avons crée un utilisateur");
              }).catchError((error){
                print(error.toString());
              });
            }else{
              alert("Le nom est vide");
            }
          }else{
            alert("Le prenom est vide");
          }
        }
      }else{
        alert("Le mot de passe est vide");
      }
    }else{
      alert("L'adresse mail vide");
    }
  }
//méthode alert(boite de message)
  Future<void>alert(String erreur) async{
    Text titre=new Text("SpeakMy Erreur");
    Text soustitre=new Text(erreur);
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext){
            //testons si android oo IOS pour choix type boite alerte
          return (Theme.of(context).platform==TargetPlatform.iOS)
              ? CupertinoAlertDialog(
                title: titre,content: soustitre,actions: <Widget>[
                  okButton(buildContext)],)
              : AlertDialog(title: titre,content: soustitre,actions: <Widget>[
                okButton(buildContext)],);
          }
    );//fin showDialog
  }//fin alert

  FlatButton okButton(BuildContext context){
    return FlatButton(
      onPressed: (){
        Navigator.of(context).pop();
      },
      child: Text('OK'),
    );
  }

  //méthode cardElement
  List<Widget>cardElement(){
    List<Widget>widgets=[];
    //ajout des zones de Texte
    widgets.add(
      TextField(
        decoration: InputDecoration(hintText: 'Entrez votre adresse mail'),
        onChanged: (string){
          setState(() {
            mail=string;
          });
        },
      )
    );

    widgets.add(
        TextField(
          obscureText: true,
          decoration: InputDecoration(hintText: 'Entrez votre mot de passe'),
          onChanged: (string){
            setState(() {
              password=string;
            });
          },
        )
    );

    //test si log est faux
    if(log==false){
      widgets.add(
          TextField(
            decoration: InputDecoration(hintText: 'Entrez votre le prénom'),
            onChanged: (string){
              setState(() {
                prenom=string;
              });
            },
          )
      );

      widgets.add(
          TextField(
            decoration: InputDecoration(hintText: 'Entrez votre le nom'),
            onChanged: (string){
              setState(() {
                nom=string;
              });
            },
          )
      );
    }//fin if
    //ajout d'un bouton
    widgets.add(
      FlatButton(
          onPressed: (){
            //action à faire si on clic
            setState(() {
              //affectons la valeur contraire de l'état actuelle du contenu
              //de la variable log
              log=!log;
            });
          },
          child: Text(
            (log==true)
              ? "Créer un compte utilisateur"
              : "Vous avez déjà un compte"
          )
    )
    );
    return widgets;
  }//fin cardElement

}
