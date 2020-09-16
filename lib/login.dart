import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<bool> _sesion;
  Future<String> _username;
  Future<String> _photo;
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool obscure = true;

  @override
  void initState() { 
    super.initState();
  }

  _login() async {
    final SharedPreferences prefs = await _prefs;
      if (_formKey.currentState.validate()) {
        List<dynamic> listUser = json.decode(await readJson());
        listUser.forEach((user) {
          if(usernameController.text == user['username'] && passController.text == user['password']){
            
              Navigator.of(context).pushNamed('home');
              prefs.setBool('sesionActive', true);
              prefs.setString('username', user['username']);
              prefs.setString('photo', user['photo_perfil']);
          }
        });
      } else {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Rellene todos los campos')));
            
      }
  }

  Future<String> readJson() async {
    try {
      return await rootBundle.loadString('assets/json/users.json');
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      width: 327,
                        child: TextFormField(
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 20,
                      ),
                      autovalidate: false,
                      controller: usernameController,
                      validator: (value) =>
                          value.isEmpty ? 'Ingrese el username' : null,
                      decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Ingrese el username',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    )),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: 327,
                      child: TextFormField(
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 20,
                        ),
                        autovalidate: false,
                        obscureText: obscure,
                        controller: passController,
                        validator: (value) =>
                            value.isEmpty ? 'Ingrese el password' : null,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Ingrese el password',

                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: (){
                              setState(() {
                                this.obscure  = !this.obscure;
                              });
                            },
                          )
                        ),
                      
                    )
                    )
                  ],
                )),
                SizedBox(
                  height: 25,
                ),
            Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(15.0),
                color: Color.fromRGBO(52, 151, 253, 1),
                shadowColor: Colors.transparent,
                child: MaterialButton(
                  minWidth: 350,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  child: Text('INICIAR SESION'),
                  onPressed: _login,
                ))
          ],
        )
        ));
  }

  Future<void> _showMyDialog(
      String title, String message, BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
