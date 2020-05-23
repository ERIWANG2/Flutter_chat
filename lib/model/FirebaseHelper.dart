import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:speackme/model/User.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:speackme/model/User.dart';

class FirebaseHelper{
  //1. authentification
  final auth=FirebaseAuth.instance;

  Future<FirebaseUser>handleSingIn(String mail,String password)async{
    final FirebaseUser user=(await auth.signInWithEmailAndPassword(
        email: mail, password: password)).user;
    return user;
  }

  Future<FirebaseUser>handleCreate(String mail,String password,
      String prenom,String nom)async{
    final FirebaseUser user=(await auth.createUserWithEmailAndPassword(
        email: mail, password: password)).user;
    String uid=user.uid;

    Map<String,String>map={
      "uid":uid,
      "prenom":prenom,
      "nom":nom
    };

    addUser(uid, map);
    return user;
  }
  //base de données
  static final bd=FirebaseDatabase.instance.reference();
  final base_user=bd.child('users');
  final base_message=bd.child("messages");
  final base_conversation=bd.child("conversations");

  addUser(String uid,Map map){
    base_user.child(uid).set(map);
  }

  Future<String> myId()async{
    //recupérons un utilisateur et on renvoi son id
    FirebaseUser user=await auth.currentUser();
    return user.uid;
  }

  //2. Obtenir l'utilisateur depuis la bd

  Future<User>getUser(String id)async{
    DataSnapshot snapshot=await base_user.child(id).once();
    return new User(snapshot);
  }

  //stockage de l'image
  static final base_storage=FirebaseStorage.instance.ref();
  final StorageReference storage_users=base_storage.child("users");
  final StorageReference storage_message=base_storage.child("messages");
  
  Future<String> savePicture(File file,StorageReference storageReference)async{
    StorageUploadTask storageUploadTask=storageReference.putFile(file);
    StorageTaskSnapshot snapshot=await storageUploadTask.onComplete;
    String url=await snapshot.ref.getDownloadURL();
    return url;
  }

  //fermeture de la session
  Future<bool>handleLogOut()async{
    await auth.signOut();
    return true;
  }

  //envoie message etre deux interlocuteur (moi et mon partenaite User)
 sendMessage(User user,User moi,String text,String imageUrl){
    String date= new DateTime.now().millisecondsSinceEpoch.toString();
    Map map={
      "from": moi.id,
      "to" : user.id,
      "text" : text,
      "imageUrl" : imageUrl,
      "dateString" :date
    };
    //recupération de la conversation entre deux utilisateur.
    // Chaque conversation a un identifiant unique qui doit être la date
    base_message.child(getMessageRef(moi.id,user.id)).child(date).set(map);
    base_conversation.child(moi.id).child(user.id).set(getConversation(moi.id, user, text, date));
    //si je parle à moi même
    base_conversation.child(user.id).child(moi.id).set(getConversation(moi.id, moi, text, date));
 }

 Map getConversation(String sender,User userPartenaire,String text,String dateString){
  //recupération du User et la convertion en Map
    Map map=userPartenaire.toMap();
    map["monId"]=sender;
    map["last_message"]=text;
    map["dateString"]=dateString;
    return map;
 }

 String getMessageRef(String from,String to){
    String resultat="";
    List<String>list=[from,to];
    //trie de Id de chaque personne
    list.sort((a,b)=>a.compareTo(b));
    for(var x in list){
      resultat +=x +"+";
    }
    return resultat;
 }

}
