import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'detect.dart';

class Cadastro extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => CadastroState();
}

class CadastroState extends State<Cadastro>
{

  var _formKey = GlobalKey<FormState>();
  String _email, _senha;
  String nome, facebook = "Default", instagram = "Default", twitter = "Default", foto = "Default";
  bool invisible = true;
  String personalId;
  

  // Cadastro de PersonID por pessoa <> Face API Azure //
  Future<PersonalClient> _createPerson() async{
    
    var url = 'https://fatecvisual.cognitiveservices.azure.com/face/v1.0/persongroups/fatecx/persons';
    var key = 'acd3aff0447946d088fcb79f8762959a';

    var body = json.encode({
      'name' : '$nome'
    });
    var header = {
      'Content-Type' : 'application/json',
      'Ocp-Apim-Subscription-Key' : key
    };

    var response = await http.post(url, body:body, headers:header);
    print ('Response status: ${response.statusCode}');


    final retorno = json.decode(response.body);
    _sendPersonId(PersonalClient.fromJson(retorno));
    return PersonalClient.fromJson(retorno);
  }

  Future<String> _sendPersonId(PersonalClient personid) async {
    personalId = personid.personId;


    return personalId;
  }
  // Termina aqui //
  
  void inContact(TapDownDetails details) {
    setState(() {
      invisible = false;
    });
  }

  void outContact(TapUpDetails details) {
    setState(() {
      invisible=true;
    });
  }


  @override
  Widget build(BuildContext context) {
       var gd =  GestureDetector(
           onTapDown: inContact,//call this method when incontact
           onTapUp: outContact,//call this method when contact with screen is removed
           child: Icon(
           Icons.remove_red_eye,
           color: Colors.grey,
   ),
      );

      var appbar = AppBar(
        backgroundColor: Color.fromRGBO(78, 91, 158, 1),
        title: new Center(child: new Text("Cadastro"),),
      );

    var txtEmail = TextFormField(
        decoration: InputDecoration(
          labelText: "E-mail"
        ),
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) => _email = value,
        validator: (value) => value != "" ? null : "E-mail obrigatório.",
      );

    var txtSenha = TextFormField(
      obscureText: invisible,
      decoration: InputDecoration(
            labelText: "Senha",
            suffixIcon: gd
          ),
            onSaved: (value) => _senha = value,
    );

        var txtNome = TextFormField(
      decoration: InputDecoration(
            labelText: "Nome",
          ),
            onSaved: (value) => nome = value,
    );

    //Teste de Validação em Cadastro//
    Future validation() async {
    try{
      var authResult =  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _senha);
      
      


        String id = authResult.user.uid;
                  
                    Firestore.instance
                    .collection('usuarios')
                    .document(id)
                    .setData({
                      "nome": nome,
                      "facebook" : facebook.isEmpty ? "" : facebook,
                      "twitter" : twitter.isEmpty ? "" : twitter,
                      "instagram" : instagram.isEmpty ? "" : instagram,
                      "foto" : foto.isEmpty ? "https://firebasestorage.googleapis.com/v0/b/iwho-15b7b.appspot.com/o/profiles%2Fdarkdragon.jpg?alt=media&token=621cc33e-e0c4-4444-b513-5321f26acf83" : foto,
                      "email" : _email,
                      "senha" : _senha,
                      "personId" : personalId
                    });

        Navigator.of(context).pushReplacementNamed('/perfil');
    }on Exception catch (e){
      print("Erro" + e.toString());
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: new Text('Erro!!'),
            content: new Text('Esta conta já existe ou o e-mail esta incorreto.'),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
    }
  }

          // Aqui termina o teste//

    // Future _cadastrar() async {

    //     var authResult =  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _senha);

    //     String id = authResult.user.uid;
                  
    //                 Firestore.instance
    //                 .collection('usuarios')
    //                 .document(id)
    //                 .setData({
    //                   "nome": nome,
    //                   "facebook" : facebook.isEmpty ? "" : facebook,
    //                   "twitter" : twitter.isEmpty ? "" : twitter,
    //                   "instagram" : instagram.isEmpty ? "" : instagram,
    //                   "email" : _email,
    //                   "senha" : _senha
    //                 });

    //     Navigator.of(context).pushReplacementNamed('/');
    // }

    var btnSalvar = RaisedButton(
                child: Text("Registrar"),
                onPressed: () {
                  _formKey.currentState.save();
                  _createPerson();
                  validation();
                },
              );

    
    var containerBotao = Container(
      child: btnSalvar,
      margin: EdgeInsets.fromLTRB(30.0, 300.0, 30.0, 0.0),
    );

    var lista = ListView(
      children: [
        txtEmail,
        txtSenha,
        txtNome,
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