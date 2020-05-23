import 'package:firebase_database/firebase_database.dart';

class User{
  String id;
  String prenom;
  String nom;
  String imageUrl;
  String initiales;
  //constructeur
  User(DataSnapshot snapshot){
    //id=snapshot.key;
    Map map=snapshot.value;
    id=map["uid"];
    prenom=map["prenom"];
    nom=map["nom"];
    imageUrl=map["imageUrl"];
    //recupération de la première lettre du prenom
    if(prenom !=null && prenom.length>0){
      initiales=prenom[0];
    }
    if(nom !=null && nom.length>0){
      if(initiales !=null){
        initiales +=nom[0];
      }else{
        initiales +=nom[0];
      }
    }
  }//fin constructeur

  //méthode pour transformer utilisateur en map
  //avant ajout à la bd firebase
  Map toMap(){
    return {
      "prenom":prenom,
      "nom":nom,
      "imageUrl":imageUrl,
      "uid":id
    };
  }


}