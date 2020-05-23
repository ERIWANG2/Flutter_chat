import 'package:speackme/model/User.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:speackme/model/DateHelper.dart';

class Conversation {
  String id;
  String last_message;
  User user;
  String date;

  Conversation(DataSnapshot snapshot){
    this.id=snapshot.value["monId"];
    String StringDate=snapshot.value["dateString"];
    this.date=DateHelper().getDate(StringDate);
    this.last_message=snapshot.value["last_message"];
    user=new User(snapshot);
  }


}