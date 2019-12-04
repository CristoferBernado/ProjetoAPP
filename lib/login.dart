import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Login extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => LoginState();
}


class LoginState extends State<Login>
{

  var _formKey = GlobalKey<FormState>();
  String _email, _senha;
  bool value4 = false;
  String id;

  


  Future authentication() async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email,password: _senha);
      Navigator.of(context).pushReplacementNamed('/search');
    }on Exception catch (e){
      print("Erro" + e.toString());
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: new Text('Erro!!'),
            content: new Text('Login ou Senha Invalidos'),
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

  void onChangedValue0(bool value)
  {
    setState(() {
     value4 = value; 
    });
  }

  bool validateAndSave()
  {
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

    bool invisible = true;
  
  
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
   ),
      );


    var btnRemember = Container(
        child: Switch(
        value: value4, onChanged: onChangedValue0,
         ),
    );

    Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  
  
    AlertDialog alerta = AlertDialog(
    title: Text("Função Lembrar Minha Senha"),
    content: Text("O botão a frente -> quando ligado lembra sua senha"),
    actions: [
      okButton,
    ],
  );


  void _exibirDialogo() {
    showDialog(
       context:  context,
       builder:  (BuildContext context) {
         return alerta;
    },
   );
}

    var lista = Container(
      decoration: BoxDecoration( 
        // image: DecorationImage(
        //   alignment: Alignment.topCenter,
        //  image: AssetImage('assets/images/whologo.png'),
        // ),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,

          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            // Colors are easy thanks to Flutter's Colors class.
            Colors.indigo[800],
            Colors.indigo[700],
            Colors.indigo[600],
            Colors.indigo[400],
          ],
        )
      ),
        child: Align(
           alignment: Alignment.center,
          child:SizedBox(
          height: 800,
        child:Container(
        color: Colors.transparent,
        child: Form(
          
            key: _formKey,
            child: ListView(
              children: [
                Column(children: [
                  
                                  Container(
                    child: Image.asset(
                        'assets/images/whologo.png',
                        fit: BoxFit.cover,
                          height: 440, // set your height
                          width: 160, // and width here
                    ),
                  ),
                //
                Row(children: [
                  Container(
                  alignment: Alignment.bottomLeft,
                  child: FlatButton(
                  child: Text("Lembrar minha senha", style: TextStyle(color: Colors.white)),
                  onPressed: (){
                    _exibirDialogo();
                  },
                ),
                ),
                btnRemember,
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                Container(child:TextFormField(
                    decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.blue),
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.account_circle),
                  ),
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => _email = value,
                  validator: (value) => value.isEmpty ? 'E-mail não pode estar vazio' : null,
                  ),
                  margin: EdgeInsets.fromLTRB(13.0, 0, 13.0, 0.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(0,185,255,1)),
                    borderRadius: BorderRadius.circular(5.0)
                  ),
                ),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      labelText: "Senha",
                      labelStyle: TextStyle(color: Colors.blue),
                      border: InputBorder.none,
                      suffixIcon: gd,
                    ),
                      style: TextStyle(color: Colors.white),
                      obscureText: invisible,
                      onSaved: (value) => _senha = value,
                      validator: (value) => value.isEmpty ? 'Senha não pode estar vazia' : null,
                  ),
                  margin: EdgeInsets.fromLTRB(13.0, 10.0, 13.0, 0.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(0,185,255,1)),
                    borderRadius: BorderRadius.circular(5.0)
                  ),
                ),
                                  Container(
                  alignment: Alignment.topRight,
                  child: FlatButton(
                  child: Text("Esqueci minha senha", style: TextStyle(color: Colors.white)),
                  onPressed: (){
                    Navigator.of(context).pushNamed('/lembrarsenha');
                  },
                ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(110.0, 0.0, 110.0, 0.0),
                  child: FlatButton(
                    color: Color.fromRGBO(0,185,255,0.5),
                    child: Text("Entrar", style: TextStyle(color: Colors.white),),
                    onPressed: () {
                    _formKey.currentState.save();
                    authentication();
                    },
                  )
                ),
                FlatButton(
                  child: Text("Cadastrar", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/cadastro');
                  },
                ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                                                //
              ],
            ),
          )
      ),
          ),
        ),
    );


      var scaffold = Scaffold( body: lista);


    return scaffold;
  }

}
