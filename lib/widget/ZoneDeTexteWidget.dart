import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:speackme/model/FirebaseHelper.dart';
import 'package:speackme/model/User.dart';

class ZoneDeTexteWidget extends StatefulWidget {
  User partenaire;
  String id;
  ZoneDeTexteWidget(User partenaire, String id){
    this.partenaire=partenaire;
    this.id=id;
  }

  @override
  _ZoneDeTexteWidgetState createState() => _ZoneDeTexteWidgetState();
}

class _ZoneDeTexteWidgetState extends State<ZoneDeTexteWidget> {
  TextEditingController _textEditingController=new TextEditingController();
  User moi;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //on récupére l'utilisateur via son id. La valeur de retour est stockée
    //dans la valeur user dont le contenu est affecte dans l'objet moi
    FirebaseHelper().getUser(widget.id).then((user){
      setState(() {
        moi = user;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.all(15.0),
      child: new Row(
        children: <Widget>[
          new IconButton(icon: new Icon(Icons.camera_enhance),
             onPressed: ()=>takePicture(ImageSource.camera)),
          new IconButton(icon: new Icon(Icons.photo_library),
                 onPressed: ()=>takePicture(ImageSource.gallery)),
          new Flexible(
              child: new TextField(
                controller:_textEditingController ,
                decoration: new InputDecoration.collapsed(hintText: "Ecrivez message"),
                maxLines: null,
              )
          ),
          IconButton(icon:new Icon(Icons.send), onPressed: _sendButtonPressed)
        ],
      ),
    );

  }
  //action à effectuer lorsqu'on presse sur le bouton sendMessage
  //le dernier paramètre correspond à l'image qui est null.
  _sendButtonPressed(){
    if(_textEditingController.text !=null && _textEditingController.text !=""){
      String text=_textEditingController.text;
      FirebaseHelper().sendMessage(widget.partenaire, moi, text,null);
      _textEditingController.clear();
      FocusScope.of(context).requestFocus(new FocusNode());
    }else{
      print("texte vide ou null");
    }
  }

  //méthode takePicture
  Future<void> takePicture(ImageSource source)async{
    File file=await ImagePicker.pickImage(source: source,maxWidth: 1000.0,maxHeight: 1000.0);
    String date=new DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseHelper().savePicture(file,
        FirebaseHelper().storage_message.child(widget.id).child(date)).then((string){
          FirebaseHelper().sendMessage(widget.partenaire, moi, null, string);
    });
  }

}
