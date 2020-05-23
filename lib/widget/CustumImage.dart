import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustumImage extends StatelessWidget {
  String imageUrl;
  String initiale;
  double radius;

 //constructeur
  CustumImage(this.imageUrl, this.initiale, this.radius);

  @override
  Widget build(BuildContext context) {
    if(imageUrl==null){
      return new CircleAvatar(
        radius: radius??0.0,
        backgroundColor: Colors.blue,
        child: Text(initiale ?? "",
          style: TextStyle(color: Colors.white,fontSize: radius),),
      );
    }else{
      ImageProvider provider=CachedNetworkImageProvider(imageUrl);
      print('imageUrl:'+imageUrl);
      print('valeur radius:'+radius.toString());
      if(radius==null){
        //image de conversation de chat//a faire après
        return new InkWell(
          child:new Image(image:provider, width: 250.0,),
         onTap: (){
            _showImage(context, provider);
         },
        );

      }else {
        return InkWell(
          child: CircleAvatar(
            radius: radius,
            backgroundImage:provider ,
          ),

          onTap: (){
            _showImage(context, provider);
          },
        );

      } //fin if
    }//if
  }

  //méthode ontape
  Future<void> _showImage(BuildContext context,ImageProvider provider){
    return showDialog(
        context: context,
      barrierDismissible: true,
      builder: (BuildContext build){
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment:MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Image(image: provider),
                new RaisedButton(
                    color: Colors.blue,
                    onPressed: ()=>Navigator.of(build).pop(),
                    child: Text("OK",
                        style:TextStyle(color:Colors.white,fontSize: 20),
                    )
                )
              ],
            ),
          );
      }
    );
  }


}
