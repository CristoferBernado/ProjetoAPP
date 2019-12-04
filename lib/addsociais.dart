import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Sociais extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => SociaisState();
}

class SociaisState extends State<Sociais>
{

  var _formKey = GlobalKey<FormState>();
  String facebook, twitter, instagram;
  
  


  @override
  Widget build(BuildContext context) {

      var appbar = AppBar(
        backgroundColor: Color.fromRGBO(78, 91, 158, 1),
        title: new Center(child: new Text("Adicionar Redes Sociais"),),
      );

    var txtFacebook = TextFormField(
        decoration: InputDecoration(
          labelText: "Facebook"
        ),
        keyboardType: TextInputType.url,
        onSaved: (value) => facebook = value,
      );

    var txtInstagram = TextFormField(
      decoration: InputDecoration(
            labelText: "Instagram",
          ),
          keyboardType: TextInputType.emailAddress,
          onSaved: (value) => instagram = value,
    );

    
    var txtTwitter = TextFormField(
      decoration: InputDecoration(
            labelText: "Twitter",
          ),
          keyboardType: TextInputType.emailAddress,
          onSaved: (value) => twitter = value,
    );


    Future<void> _updateUser() async {
      var user = await FirebaseAuth.instance.currentUser();
      
      await Firestore.instance.collection("usuarios").document(user.uid).updateData({
                      "facebook" : this.facebook,
                      "twitter" : this.twitter,
                      "instagram" : this.instagram
                    });

        Navigator.of(context).pop("From RaisedButton");
    }

    var btnSalvar = RaisedButton(
                child: Text("Adicionar ao Perfil"),
                onPressed: () {
                  
                  _formKey.currentState.save();
                  _updateUser();
                  
                },
              );

    
    var containerBotao = Container(
      child: btnSalvar,
      margin: EdgeInsets.fromLTRB(30.0, 300.0, 30.0, 0.0),
    );

    var lista = ListView(
      children: [
        txtFacebook,
        txtInstagram,
        txtTwitter,
        containerBotao
      ],
    );

    var containerCadastro = Container(
      child: lista,
      margin: EdgeInsets.fromLTRB(30.0, 60.0, 30.0, 0.0),
    );

     var form = Form(key: _formKey, child: containerCadastro);




    return Scaffold(body: form, appBar: appbar);
  }
  
}