import 'package:flutter/material.dart';


InputDecoration textformFieldDecoration(String hintText) {
  return InputDecoration(
      enabledBorder: InputBorder.none,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      fillColor: Colors.grey[200],
      filled: true,
      
      hintText: hintText,
      
      hintStyle: TextStyle(
        color: Colors.black,
      ));
}

class ShowError extends StatelessWidget {
  final String error;

  const ShowError({Key key, this.error}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
    width: double.infinity,
    color: Colors.red[200],
    child: Row(
      children: <Widget>[
        Icon(Icons.error_outline),
        Text(error),
        IconButton(icon: Icon(Icons.clear), onPressed: (){
          print("clear clicked");
        })
      ],
    ),

  );
  }
}