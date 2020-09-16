import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
String photo;
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<List<dynamic>> lista =  Future<List<dynamic>>.delayed(Duration(seconds: 2));

  Future<String> _photo = Future<String>.delayed(
    Duration(seconds: 1),
    () async{
      final SharedPreferences prefs = await _prefs;
      photo = prefs.getString('photo');
      return prefs.getString('photo');
    },
  );

  

  Future<String> _username = Future<String>.delayed(
    Duration(seconds: 2),
    () async{
      final SharedPreferences prefs = await _prefs;
      return prefs.getString('username');
    },
  );
  @override
  void initState() { 
    super.initState();
    this.getList();
    this._photo;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: 
          DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2,
      textAlign: TextAlign.center,
      child: FutureBuilder<List<dynamic>>(
        future: lista, // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
             return ListView.builder(
               itemCount: snapshot.data.length,
               itemBuilder:(context,index){
                 return Card(
                   child:Row(
                     children: [
                       Image.asset(photo,width: 200,height: 200,),
                       Container(
                        child: Text(snapshot.data[index]['name']+'\n'+
                                    snapshot.data[index]['email']+'\n'+
                                    snapshot.data[index]['username']),
                      ),
                       
                     ],
                   ),
                 );
             } );

          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    ),
    );
  }

  getList(){
    get(Uri.encodeFull('https://jsonplaceholder.typicode.com/users')).then((response){
      if(response.statusCode == 200){
        this.lista = this.lista.then((value){
          return json.decode(response.body);
        });
        setState((){});
      }
    });
  }
}
