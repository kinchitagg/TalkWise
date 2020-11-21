import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  getUserInfobyUserName(String username) async {
    return await Firestore.instance
        .collection("User")
        .where("Username", isEqualTo: username)
        .getDocuments();
  }

  getUserInfobyEmail(String email) async {
    return await Firestore.instance
        .collection("User")
        .where("Email", isEqualTo: email)
        .getDocuments();
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection("User").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  createChatConco(String chatRoomId, chatRoomMap) async {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .setData(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addMessage(String chatRoomId, messageMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .collection("Chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getMessageStream(String chatRoomId) async {
    return Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .collection("Chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  getChatRooms(String username) async {
    return Firestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: username)
        .snapshots();
  }
}
