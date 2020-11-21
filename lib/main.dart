import 'package:chatar_patar/helper/sharedpreferences.dart';
//import 'package:chatar_patar/screens/addContact.dart';
import 'package:chatar_patar/screens/chatRoom.dart';
import 'package:flutter/material.dart';
import 'helper/authenticate.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatar Patar',
      theme: ThemeData.dark(),
      home: Wrapper(),
    );
  }
}

class Wrapper extends StatefulWidget {

  
  
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  bool isLoggedIn ;

  @override
  void initState() {
    getLoginStatus();
    super.initState();
  }

  getLoginStatus() async{
    isLoggedIn = await HelperFunction.getUserLoginKeySharedPreferenced();
    setState(() {
      print(isLoggedIn.toString());
    });
  }
  @override
  Widget build(BuildContext context) {
     if(isLoggedIn == true){return ChatRoom();}
     else return Authenticate();}
}
