import 'package:chatar_patar/services/database.dart';
import 'package:chatar_patar/shared/constants.dart';
import 'package:flutter/material.dart';

class ChatConvo extends StatefulWidget {
  final String username;
  final String chatRoomId;

  const ChatConvo({Key key, this.username, this.chatRoomId}) : super(key: key);
  @override
  _ChatConvoState createState() => _ChatConvoState();
}

class _ChatConvoState extends State<ChatConvo> {
  TextEditingController messageController = new TextEditingController();
  DatabaseService databaseService = new DatabaseService();
  Stream messageSnapshot;

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      databaseService.addMessage(widget.chatRoomId, messageMap);
    }
  }

  @override
  void initState() {
    databaseService.getMessageStream(widget.chatRoomId).then((value) {
      setState(() {
        messageSnapshot = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String username = widget.username;
    //String chatRoomId = widget.chatRoomId;
    // print(username);
    // print(chatRoomId);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        title: Row(
          children: <Widget>[
            CircleAvatar(
              child: Text(username.substring(0, 1).toUpperCase()),
              backgroundColor: Colors.blue[200],
            ),
            SizedBox(
              width: 20,
            ),
            Text(username),
          ],
        ),
      ),
      // backgroundColor: Colors.,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(bottom: 100),
                //padding: EdgeInsets.only(bottom: 10),
                child: messageList()),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                color: Colors.black,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: messageController,
                        //textInputAction: TextInputAction.send,
                        style: TextStyle(color: Colors.white),
                        maxLines: null,
                        expands: true,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 20),
                            //enabledBorder: InputBorder.none,
                            fillColor: Colors.grey[800],
                            hintText: "message",
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          sendMessage();
                          messageController.clear();
                        },
                        child: CircleAvatar(
                          child: Icon(Icons.send),
                          backgroundColor: Colors.grey,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget messageList() {
    return StreamBuilder(
        stream: messageSnapshot,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return ListView.builder(
                shrinkWrap: true,
                reverse: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  // print("${snapshot.data}");
                  return MessageTile(
                    message: snapshot.data.documents[index].data["message"],
                    isSendbyMe: snapshot.data.documents[index].data["sendBy"] ==
                        Constants.myName,
                  );
                });
          } else
            return Container(
              child: Center(child: CircularProgressIndicator()),
            );
        });
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendbyMe;
  const MessageTile({Key key, this.message, this.isSendbyMe}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 5),
      alignment: isSendbyMe ? Alignment.centerRight : Alignment.centerLeft,
      //color: Colors.blue,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 2.2 / 3),
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: isSendbyMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.zero)
                  : BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      bottomLeft: Radius.zero),
              gradient: LinearGradient(
                colors: isSendbyMe
                    ? [Colors.blue[200], Colors.blue]
                    : [Colors.grey, Colors.grey[400]],
              ),
            ),
            child: Text(
              message,
              style: TextStyle(fontSize: 17),
              maxLines: null,
              
            )),
      ),
    );
  }
}
