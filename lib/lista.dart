import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Lista extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return ListaState();      
  }
}

class ListaState extends State<Lista>
{
  FirebaseUser user;

  var _loading = true;
  

  @override
  Widget build(BuildContext context) {

    // var lista = ListView(
    //   children: [
    //     ItemContato("Tony Stark", "tony@marvel.com"),
    //     ItemContato("Steve Rogers", "steve@marvel.com"),
    //   ]
    // );

    Future.delayed(Duration.zero,() async {
      setState(() async {
        user = await FirebaseAuth.instance.currentUser();   
        this._loading = false;            
      });
    });
    
    Widget _lista() { 
      return StreamBuilder(
        stream: Firestore.instance
            .collection('usuarios')
            .where("uid", isEqualTo: user.uid)
            // .orderBy("nome", descending: true)
            // .where("nome", isGreaterThanOrEqualTo: "Tony")
            .snapshots(),
        builder: (context, snapshots) {

          if(!snapshots.hasData)
            return Center(
              child: CircularProgressIndicator()
            );

          return ListView.builder(
            itemCount: snapshots.data.documents.length,
            itemBuilder: (context, index) {
              var doc = snapshots.data.documents[index];
              return ItemContato(doc["nome"], doc["email"], doc.documentID);
            },
          );
        },
      );
    }

    var appBar = AppBar(
      title: Text("Contatos")
    );

    var fab = FloatingActionButton(
      tooltip: "Adicionar Contato",
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.of(context).pushNamed('/perfil');
      },
    );

    return Scaffold(
      appBar: appBar,
      body: this._loading ?  ListView() : _lista(),
      floatingActionButton: fab, 
    );
  }
}


class ItemContato extends StatelessWidget
{
  final String nome;
  final String email;
  final String id;

  ItemContato(this.nome, this.email, this.id);

  @override
  Widget build(BuildContext context) {

    var imagem = CircleAvatar(
      radius: 20.0,
      backgroundImage: NetworkImage("https://observatoriodocinema.bol.uol.com.br/wp-content/uploads/2019/05/cropped-tony-stark-header-2.jpg"),
    );
    
    var coluna = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(this.nome),
        Text(this.email,
          style: TextStyle(
            color: Colors.grey[700]
          )
        )
      ],
    );

    var containerColuna = Container(
      margin: EdgeInsets.only(left: 3.0),
      child: coluna,
    );
    
    var row = Row(
      children: [
        imagem,
        //Container(width: 3.0,),
        containerColuna
      ],
    );


    var container = Container(
      margin: EdgeInsets.fromLTRB(6.0, 8.0, 6.0, 0.0),
      child: row,
      color: Colors.transparent,
    );

    var gd = GestureDetector(
      child: container,
      onTap: () => Navigator.of(context)
        .pushNamed('/perfil', arguments: this.id)
    );

    return gd;
  }
}