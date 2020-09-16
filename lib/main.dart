import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tarea1/home.dart';
import 'package:tarea1/login.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  MyApp();
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  String initialRoute = "";
  @override
  Widget build(BuildContext context) {
    setState((){
      
    });
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: initialRoute,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case 'login':
            return MaterialPageRoute(
                builder: (context) => LoginPage(
                      title: 'Login',
                    ));
          case 'home':
            return MaterialPageRoute(builder: (context) => HomePage());
          default: 
            return MaterialPageRoute(builder: (context)=> PrincipalPage());
        }
      },
    );
  }
}

class PrincipalPage extends StatefulWidget {
  PrincipalPage({Key key}) : super(key: key);

  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    goingTo();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(body: Image.asset('assets/images/perfil2.jpg'),);
  }

  goingTo() async{
    final SharedPreferences prefs = await _prefs;
    bool s = prefs.getBool('sesionActive');
    if(s == true){
      Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    }
  }
}

