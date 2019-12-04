import 'dart:convert';
import 'dart:io';    
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore    
import 'package:flutter/material.dart';  
import 'package:image_picker/image_picker.dart'; // For Image Picker    
import 'package:path/path.dart' as Path;
import 'package:http/http.dart' as http; 

class CameraPage extends StatefulWidget{
  @override
  _State createState() => _State();
}

class _State extends State<CameraPage>{
  String personId;
  File imageFile;
  String _uploadedFileURL;

  Future uploadFile() async {
   this.personId = ModalRoute.of(context).settings.arguments;    
   StorageReference storageReference = FirebaseStorage.instance    
       .ref()    
       .child('profiles/${Path.basename(imageFile.path)}}');    
   StorageUploadTask uploadTask = storageReference.putFile(imageFile);    
   await uploadTask.onComplete;    
   print('File Uploaded');
  //  if(uploadTask.onComplete!= null)
  //  {
  //    Navigator.of(context).pop("From RaisedButton");
  //  }    
   await storageReference.getDownloadURL().then((fileURL) {    
     setState(() {    
       _uploadedFileURL = fileURL;
       _addFaceOnPerson();
     });    
   });    
 } 

 // Implementação do Reconhecimento Facial Azure API -- Inserção de rosto no perfil //

  Future<void> _addFaceOnPerson() async{

    var url = 'https://fatecvisual.cognitiveservices.azure.com/face/v1.0/persongroups/fatecx/persons/${this.personId}/persistedFaces';
    var key = 'acd3aff0447946d088fcb79f8762959a';

    var body = json.encode({
      'url' : '$_uploadedFileURL'
    });
    var header = {
      'Content-Type' : 'application/json',
      'Ocp-Apim-Subscription-Key' : key
    };

    var response = await http.post(url, body:body, headers:header);
    print ('Response status: ${response.statusCode}');
    print ('Face Adicionada com Sucesso! : ${response.body}');
  }

 // Termina aqui a função para isso //

  _openGalery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  _openCam(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context){
    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        title: Text("Faça uma escolha"),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              GestureDetector(
                child: Text("Galeria"),
                onTap: () {
                  _openGalery(context);
                },
              ),
              Padding(padding: EdgeInsets.all(8.0),),
              GestureDetector(
                child: Text("Camera"),
                onTap: () {
                  _openCam(context);
                },
              )
            ],
          ),
        ),
      );
    });
  } 


  Widget _decideImageView() {
    if(imageFile == null)
    {
      return Text("Not Image Found");
    }else{
      return Image.file(imageFile, width:190, height: 190);
    }
  }

  Widget _decideImagePerfil() {
    if(_uploadedFileURL == null)
    {
      return Text("Sem imagem de perfil");
    }else {
      _updateFoto();
      return Image.network(_uploadedFileURL, width: 200, height:200);
    }
  }

  Future<void> _updateFoto() async {
      var user = await FirebaseAuth.instance.currentUser();
      
      await Firestore.instance.collection("usuarios").document(user.uid).updateData({
                      "foto" : _uploadedFileURL,
                    });

                    Navigator.of(context).pop("From RaisedButton");
    }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text("Camera App"),
      ),
      body: Container(
        child: Center(
          child:
          Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:
           <Widget>[
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                 _decideImageView(),
                 _decideImagePerfil()
               ],
             ),
            //  _decideImageView(),
            //  Image.network(_uploadedFileURL),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                  RaisedButton(
               onPressed: () {
                 _showChoiceDialog(context);
               },
               child: Text("Tirar Foto")
               ),
               RaisedButton(
                onPressed: () {
                  uploadFile();
                },
                child: Text("Atualizar Foto"),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/search');
                },
                child: Text("Procurar Pessoa"),
              )
               ],
             ),
            //  RaisedButton(
            //    child: Text("Remover Foto"),
            //    onPressed: () {
            //      imageFile = null;
            //      _decideImageView();
            //    },
            //  )
          ],
        ),
        )
      ),
      // body: ListView(
      //   children: [
      //     Container(
      //       width: 500,
      //       height: 500,
      //       child: this.imagem == null 
      //       ? Placeholder()
      //       : Image.file(this.imagem)
      //     ),
      //     FlatButton(
      //       child: Icon(Icons.add_a_photo, size: 98.0, color: Colors.black12,),
      //       onPressed: tirarFoto,
      //     ),
      //     uploading ? Text("Uploading") : Container()
      //   ],
      // ),
    );
  }
}