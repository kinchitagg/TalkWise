import 'package:chatar_patar/helper/authenticate.dart';
import 'package:chatar_patar/helper/sharedpreferences.dart';
import 'package:chatar_patar/screens/Profile.dart';
import 'package:chatar_patar/screens/addContact.dart';
import 'package:chatar_patar/screens/chatconco.dart';
import 'package:chatar_patar/services/auth.dart';
import 'package:chatar_patar/services/database.dart';
import 'package:chatar_patar/shared/constants.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthService authService = new AuthService();
  DatabaseService databaseService = new DatabaseService();
  Stream chatRoomSnapshot;

  @override
  void initState() {
    getChats();
    print(Constants.myName);

    super.initState();
  }

  getChats() async {
    Constants.myName = await HelperFunction.getUsernameSharedPreferences();
    Constants.myEmail = await HelperFunction.getEmailSharedPreferences();
    databaseService.getChatRooms(Constants.myName).then((val) {
      setState(() {
        chatRoomSnapshot = val;
      });
      //print(Constants.myName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.person_outline), onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return Profile();
            }));
          }),
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                authService.signOut();
                HelperFunction.saveUserLoginKeySharedPreferences(false);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return Authenticate();
                }));
              })
        ],
      ),
      body: chatRoom(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddContact();
            }));
          }),
    );
  }

  Widget chatRoom() {
    return StreamBuilder(
        stream: chatRoomSnapshot,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return ListView.separated(
                itemCount: snapshot.data.documents.length,
                separatorBuilder: (context, index) {
                  return Divider(
                    thickness: 0.6,
                    indent: 20,
                    endIndent: 20,
                  );
                },
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                    username: snapshot.data.documents[index].data["chatRoomId"]
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId:
                        snapshot.data.documents[index].data["chatRoomId"],
                  );
                });
          } else
            return Center(child: CircularProgressIndicator());
        });
  }
}

class ChatRoomTile extends StatelessWidget {
  final String username;
  final String chatRoomId;

  const ChatRoomTile({Key key, this.username, this.chatRoomId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatConvo(
            username: username,
            chatRoomId: chatRoomId,
          );
        }));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              child: Text(username.substring(0, 1).toUpperCase(),style: TextStyle(color: Colors.white),),
              backgroundColor: Colors.blue,
            ),
            SizedBox(width: 10),
            Text(
              username,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
