import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_live_chat_app/services/storage_base.dart';

class FirebaseStorageService implements StorageBase {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  StorageReference _storageReference;

  @override
  Future<String> uploadFile(
      String userID, String fileType, String fileName, File fileToUpload) async {
    _storageReference = _firebaseStorage.ref().child(fileType).child(userID).child(fileName).child(fileName);
    StorageUploadTask _storageUploadTask =
        _storageReference.putFile(fileToUpload);

    var _fileDownloadUrl =
        await (await _storageUploadTask.onComplete).ref.getDownloadURL();
    return _fileDownloadUrl;
  }
}
