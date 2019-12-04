import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Perfil extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PerfilState();
}

class PerfilState extends State<Perfil> {
  File imageFile;
  bool invisible = false;


  String id;
  String nome = '';
  String email = '';
  String facebook = '';
  String instagram = '';
  String twitter = '';
  String foto = '';
  String personId = '';

  bool loading = true;

  //  this.id = ModalRoute.of(context).settings.arguments;

  @override
  void initState() {
    super.initState();

    this.facebook = "";
    this.instagram = "";
    this.twitter = "";
    this.foto = "";
    this.personId = "";

    _getUserData();
  }

  Future<void> _getUserData() async {
    var _user = await FirebaseAuth.instance.currentUser();
    // var _nome = await Firestore.instance.collection('usuarios').document('personId').get();

    var documento = await Firestore.instance
        .collection('usuarios')
        .document(_user.uid)
        .get();

    setState(() {
      this.nome = documento.data['nome'];
      this.facebook = documento.data['facebook'];
      this.instagram = documento.data['instagram'];
      this.twitter = documento.data['twitter'];
      this.foto = documento.data['foto'];
      this.personId = documento.data['personId'];

      this.loading = false;
    });
  }

  Future<void> _afterSelfie() async {
    await Navigator.of(context).pushNamed('/camerapage', arguments: this.personId);
    _getUserData();
  }

  Future<void> _afterSearch() async {
    await Navigator.of(context).pushNamed('/search');
    _getUserData();
  }

  Future<void> _afterSocialUpdate() async {
    await Navigator.of(context).pushNamed('/addsociais');
    _getUserData();
  }

  void inContact(TapDownDetails details) {
    setState(() {
      invisible = false;
      _afterSocialUpdate();
    });
  }

  void outContact(TapUpDetails details) {
    setState(() {
      invisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _getUserData();

    var gd = GestureDetector(
      onTapDown: inContact, //call this method when incontact
      onTapUp:
          outContact, //call this method when contact with screen is removed
      child: Icon(
        Icons.group_add,
      ),
    );

    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    var appbar = AppBar(
      title: new Center(
        child: new Text("Perfil"),
      ),
      backgroundColor: Color.fromRGBO(36, 42, 74, 1),
      actions: <Widget>[
        gd,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.group_add,
              color: Colors.transparent,
            ),
          ],
        ),
      ],
    );

    // Inicio dos testes para usar o Doc na coleção como perfil //

    // Teste de Future para setar o perfil com os dados do Doc da Coleção //
    // Teste //
    AlertDialog alertFace = AlertDialog(
      title: Text("Facebook Link"),
      content: Text(this.facebook),
      actions: [
        okButton,
      ],
    );

    void dialogFace() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertFace;
        },
      );
    }

    AlertDialog alertInsta = AlertDialog(
      title: Text("Instagram Link"),
      content: Text(this.instagram),
      actions: [
        okButton,
      ],
    );

    void dialogInsta() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertInsta;
        },
      );
    }

    AlertDialog alertTwitter = AlertDialog(
      title: Text("Twitter Link"),
      content: Text(this.twitter),
      actions: [
        okButton,
      ],
    );

    void dialogTwitter() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertTwitter;
        },
      );
    }

    // Teste //

    var facebook = Container(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/facebook.jpeg'),
            fit: BoxFit.cover,
          ),
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10.0)),
      child: FlatButton(
        padding: EdgeInsets.fromLTRB(40.0, 40.0, 40.0, 40.0),
        child: Text(' '),
        onPressed: () {
          dialogFace();
        },
      ),
    );

    var instagram = Container(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/instagram.png'),
            fit: BoxFit.cover,
          ),
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10.0)),
      child: FlatButton(
        padding: EdgeInsets.fromLTRB(40.0, 40.0, 40.0, 40.0),
        child: Text(' '),
        onPressed: () {
          dialogInsta();
        },
      ),
    );

    var twitter = Container(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/twitter.png'),
            fit: BoxFit.cover,
          ),
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10.0)),
      child: FlatButton(
        padding: EdgeInsets.fromLTRB(40.0, 40.0, 40.0, 40.0),
        child: Text(' '),
        onPressed: () {
          dialogTwitter();
        },
      ),
    );

    var teste = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 625.5,
          width: 400,
          decoration: BoxDecoration(
            image: DecorationImage(
              // centerSlice: Rect.fromLTWH(50, 50, 100, 100),
              fit: BoxFit.cover,
              image: NetworkImage(this.foto),
            ),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
            color: Colors.transparent,
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Text(
                  this.nome,
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.blueAccent,
                  child: Icon(
                    Icons.camera_alt,
                    size: 35,
                  ),
                  elevation: 50,
                  onPressed: () {
                    // _afterSelfie();
                    _afterSearch();
                  },
                ),
                //                 FloatingActionButton(
                //   backgroundColor: Colors.blueAccent,
                //   child: Icon(
                //     Icons.linked_camera,
                //     size: 35,
                //   ),
                //   elevation: 50,
                //   onPressed: () {
                //     // _afterSelfie();
                //     _afterSearch();
                //   },
                // ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 140,
            width: 1000,
            child: Container(
              color: Colors.transparent,
              child: Container(
                color: Color.fromRGBO(36, 42, 74, 1),
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    instagram,
                    facebook,
                    twitter,
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
        body: this.loading ? Center(child: CircularProgressIndicator()) : teste,
        appBar: appbar);
  }
}
