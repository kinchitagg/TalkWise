import 'package:chatar_patar/screens/signIn.dart';
import 'package:chatar_patar/screens/signUp.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool isShowingSignIn = true;
    void toggleView(){
      setState(() {
        isShowingSignIn = !isShowingSignIn;
      });
    }
  @override
  Widget build(BuildContext context) {
    
    
    
    return isShowingSignIn == true ? SignIn(callBack: toggleView) : SignUp( callBack: toggleView);
      
    
  }
}