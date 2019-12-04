import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecSenha extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => RecSenhaState();
}

class RecSenhaState extends State<RecSenha>
{

  var _formKey = GlobalKey<FormState>();
  String _email;
  String nome, email, senha, confsenha;



  @override
  Widget build(BuildContext context) {

      var appbar = AppBar(
        backgroundColor: Color.fromRGBO(78, 91, 158, 1),
        title: new Center(child: new Text("Recuperar Senha"),),
      );

    var txtEmail = TextFormField(
        decoration: InputDecoration(
          labelText: "E-mail"
        ),
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) => _email = value,
        validator: (value) => value != "" ? null : "E-mail obrigatório.",
      );


    var btnSalvar = RaisedButton(
                color: Color.fromRGBO(0,185,255,0.5),
                child: Text("Recuperar Senha", style: TextStyle(color: Colors.white),),
                onPressed: () {
                  _formKey.currentState.save();

                  FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
                  Navigator.of(context).pushReplacementNamed('/login');         
                },
              );

    
    var containerBotao = Container(
      child: btnSalvar,
      margin: EdgeInsets.fromLTRB(30.0, 300.0, 30.0, 0.0),
    );

    var lista = ListView(
      children: [
        txtEmail,
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