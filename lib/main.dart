import 'package:flutter/material.dart';
import 'lista.dart';
import 'splash.dart';
import 'login.dart';
import 'camerapage.dart';
import 'cadastro.dart';
import 'lembrarsenha.dart';
import 'perfil.dart';
import 'addsociais.dart';
import 'search.dart';
import 'foundperfil.dart';

void main() 
{
  var app = WhoApp();
  runApp(app);
}

class WhoApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {

    var routes = {
      '/lista' : (context) => Lista(),
      '/cadastro' : (context) => Cadastro(),
      '/splash' : (context) => Splash(),
      '/addsociais' : (context) => Sociais(),
      '/foundperfil' : (context) => FoundPerfil(),
      '/' : (context) => Login(),
      '/camerapage' : (context) => CameraPage(),
      '/search' : (context) => SearchPage(),
      '/lembrarsenha' : (context) => RecSenha(),
      '/perfil' : (context) => Perfil()
    };

    var materialApp = MaterialApp(routes: routes, initialRoute: '/splash',);

    return materialApp;
  }

}