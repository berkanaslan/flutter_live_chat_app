import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_live_chat_app/models/chats_model.dart';
import 'package:flutter_live_chat_app/models/message_model.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:flutter_live_chat_app/services/db_base.dart';

class FirestoreDBService implements DBBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(UserModel userModel) async {
    await _firestore
        .collection("users")
        .doc(userModel.userID)
        .set(userModel.toMap());

    return true;
  }

  @override
  Future<UserModel> readUser(String userID) async {
    DocumentSnapshot _readingValues =
        await _firestore.collection('users').doc(userID).get();

    Map<String, dynamic> _readingValuesMap = _readingValues.data();
    UserModel _userModelObject = UserModel.fromMap(_readingValuesMap);
    print("Okunan UserModel nesnesi: " + _userModelObject.toString());
    return _userModelObject;
  }

  @override
  Future<bool> updateUserName(String userID, String userName) async {
    var otherUserNames = await _firestore
        .collection('users')
        .where('userName', isEqualTo: userName)
        .get();

    if (otherUserNames.docs.isNotEmpty) {
      return false;
    } else {
      await _firestore
          .collection('users')
          .doc(userID)
          .update({'userName': userName});
      return true;
    }
  }

  updateProfilePhoto(String userID, String profilePhotoUrl) async {
    await _firestore
        .collection('users')
        .doc(userID)
        .update({'profilePhotoUrl': profilePhotoUrl});
    return true;
  }

  Future<bool> checkUserDocExist(String userID) async {
    DocumentSnapshot _snapshot =
        await _firestore.collection('users').doc(userID).get();
    if (_snapshot.exists) {
      print("Kullanıcı veritabanına kayıtlı.");
      return true;
    } else {
      print("Kullanıcı veritabanına kayıtlı değil");
      return false;
    }
  }

  @override
  Stream<List<MessageModel>> getMessages(
      String currentUserID, String chatUserID) {
    var docID = currentUserID + "--" + chatUserID;
    var snapshots = _firestore
        .collection("chats")
        .doc(docID)
        .collection("messages")
        .orderBy("date", descending: false)
        .snapshots();

    return snapshots.map((msgList) =>
        msgList.docs.map((msg) => MessageModel.fromMap(msg.data())).toList());
  }

  Future<bool> saveMessage(MessageModel sendingMessage) async {
    var _msgID = _firestore.collection("chats").doc().id;
    var _myDocID = sendingMessage.fromWho + "--" + sendingMessage.toWho;
    var _receiverDocID = sendingMessage.toWho + "--" + sendingMessage.fromWho;

    var _sendingMessageMap = sendingMessage.toMap();

    await _firestore
        .collection("chats")
        .doc(_myDocID)
        .collection("messages")
        .doc(_msgID)
        .set(_sendingMessageMap);

    await _firestore.collection("chats").doc(_myDocID).set({
      'chatOwner': sendingMessage.fromWho,
      'chatUser': sendingMessage.toWho,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': true,
      'lastMessage': sendingMessage.message,
      'readedTime': FieldValue.serverTimestamp(),
    });

    _sendingMessageMap.update("isFromMe", (value) => false);

    await _firestore
        .collection("chats")
        .doc(_receiverDocID)
        .collection("messages")
        .doc(_msgID)
        .set(_sendingMessageMap);

    await _firestore.collection("chats").doc(_receiverDocID).set({
      'chatOwner': sendingMessage.toWho,
      'chatUser': sendingMessage.fromWho,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': true,
      'lastMessage': sendingMessage.message,
      'readedTime': FieldValue.serverTimestamp(),
    });

    return true;
  }

  @override
  Future<List<ChatModel>> getAllConversations(String currentUserID) async {
    QuerySnapshot _querySnapshot = await _firestore
        .collection("chats")
        .where("chatOwner", isEqualTo: currentUserID)
        .orderBy("createdAt", descending: true)
        .get();

    List<ChatModel> _allConversations = [];

    for (DocumentSnapshot _singleMap in _querySnapshot.docs) {
      ChatModel _single = ChatModel.fromMap(_singleMap.data());
      _allConversations.add(_single);
    }

    return _allConversations;
  }

  Future<UserModel> getUser(String userID) async {
    DocumentSnapshot _docSnapshot =
        await _firestore.collection("users").doc(userID).get();
    UserModel _user = UserModel.fromMap(_docSnapshot.data());
    return _user;
  }

  @override
  Future<DateTime> showTime(String userID) async {
    await _firestore.collection("server").doc(userID).set(
      {
        "time": FieldValue.serverTimestamp(),
      },
    );

    DocumentSnapshot _s =
        await _firestore.collection("server").doc(userID).get();

    Timestamp _data = _s.data()["time"];
    return _data.toDate();
  }

  @override
  Future<List<UserModel>> getAllUsersWithPagination(
      UserModel calledLastUser, int itemsPerPage) async {
    QuerySnapshot _querySnapshot;
    List<UserModel> _allUsers = [];

    if (calledLastUser == null) {
      _querySnapshot = await _firestore
          .collection("users")
          .orderBy("userName")
          .limit(itemsPerPage)
          .get();
    } else {
      _querySnapshot = await _firestore
          .collection("users")
          .orderBy("userName")
          .startAfter([calledLastUser.userName])
          .limit(itemsPerPage)
          .get();

      await Future.delayed(Duration(seconds: 1));
    }

    for (DocumentSnapshot snap in _querySnapshot.docs) {
      UserModel _singleUser = UserModel.fromMap(snap.data());
        _allUsers.add(_singleUser);
      
    }

    return _allUsers;
  }
}
