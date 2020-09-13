import 'dart:io';

abstract class StorageBase {
  Future<String> uploadFile(
      String userID, String fileType, String fileName, File fileToUpload);
}
