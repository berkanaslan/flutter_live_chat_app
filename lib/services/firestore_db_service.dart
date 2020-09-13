import 'package:cloud_firestore/cloud_firestore.dart';
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
}
