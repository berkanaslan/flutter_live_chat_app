import 'package:flutter_live_chat_app/models/user_model.dart';

abstract class DBBase {
    Future<bool> saveUser(UserModel userModel);

}