import 'package:chatar_patar/screens/chatconco.dart';
import 'package:chatar_patar/services/database.dart';
import 'package:chatar_patar/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddContact extends StatefulWidget {
  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  DatabaseService databaseService = new DatabaseService();
  TextEditingController _searchedUsername = new TextEditingController();
  QuerySnapshot snapshot;
  initiateSearch() {
    databaseService.getUserInfobyUserName(_searchedUsername.text).then((val) {
      setState(() {
        snapshot = val;
      });
    });
  }

  createChatConvo(String username) {
    if(username != Constants.myName){
      List<String> users = [username, Constants.myName];
    String chatRoomId = getChatRoomId(username, Constants.myName);
    Map<String, dynamic> chatRoomMap = {
      "chatRoomId": chatRoomId,
      "users": users,
    };
    databaseService.createChatConco(chatRoomId, chatRoomMap);
    _searchedUsername.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return ChatConvo(username: username,chatRoomId: chatRoomId,);
    }));
    }else print("You can not message yourself");
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        elevation: 0.0,
        backgroundColor: Colors.black,
      ),
      body: Container(
          child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.black,
            padding: EdgeInsets.only(top: 1.0, bottom: 20, left: 20, right: 20),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                      controller: _searchedUsername,
                      decoration: InputDecoration(
                        fillColor: Colors.black54,
                        filled: true,
                        hintText: "Username",
                        //hintStyle: TextStyle(color:Colors.white),
                        border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                          const Radius.circular(5),
                        )),
                      )),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    print(_searchedUsername.text);
                    //initiateSearch();
                    if (_searchedUsername != null ||
                        _searchedUsername.toString().length >= 6) {
                      initiateSearch();
                    }
                  },
                  child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey),
                      child: Icon(Icons.search)),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          searchList(),
        ],
      )),
    );
  }

  Widget searchList() {
    return snapshot != null
        ? ListView.separated(
            itemCount: snapshot.documents.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return Divider(
                indent: 20,
                endIndent: 20,
              );
            },
            itemBuilder: (context, index) {
              return searchTile(
                username: snapshot.documents[index].data["Username"],
                email: snapshot.documents[index].data["Email"],
              );
            })
        : Container();
  }

  Widget searchTile({String username, String email}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                username,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(email)
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () => createChatConvo(username),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text("Message"),
            ),
          )
        ],
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0))
    return "$b\_$a";
  else
    return "$a\_$b";
}
