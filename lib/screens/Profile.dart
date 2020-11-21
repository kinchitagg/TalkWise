import 'package:chatar_patar/shared/constants.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            
            Text("Username",style: TextStyle(fontSize: 24,color: Colors.blue),),
            Text("${Constants.myName}",style: TextStyle(fontSize: 20),),
            SizedBox(height: 30,),
            Text("Email",style: TextStyle(fontSize: 24,color: Colors.blue)),
            Text("${Constants.myEmail}",style: TextStyle(fontSize: 20),),
          ],
        ),
      ),
    );
  }
}