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

    DocumentSnapshot _readingValues =
        await _firestore.doc("users/" + userModel.userID + "/").get();

    Map _readingValuesMap = _readingValues.data();
    UserModel _userModelObject = UserModel.fromMap(_readingValuesMap);
    print("Okunan UserModel nesnesi: " + _userModelObject.toString());

    return true;
  }
}
