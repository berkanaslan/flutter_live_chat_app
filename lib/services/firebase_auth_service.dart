import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:flutter_live_chat_app/services/auth_base.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserModel _userFromFirebase(User user) {
    if (user == null) {
      return null;
    } else {
      return UserModel(userID: user.uid);
    }
  }

  @override
  UserModel currentUser() {
    try {
      User user = _firebaseAuth.currentUser;
      return _userFromFirebase(user);
    } catch (e) {
      print("Current user çağırılırken hata: " + e.toString());
      return null;
    }
  }

  @override
  Future<UserModel> signInAnonymously() async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(userCredential.user);
    } catch (e) {
      print("Misafir olarak oturum açarken hata: " + e.toString());
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print("Çıkış yaparken hata: " + e.toString());
      return false;
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn();
      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();

      if (_googleUser != null) {
        GoogleSignInAuthentication _googleAuth =
            await _googleUser.authentication;
        if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
          UserCredential credential = await _firebaseAuth.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: _googleAuth.idToken,
                  accessToken: _googleAuth.accessToken));
          User _user = credential.user;
          return _userFromFirebase(_user);
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Google ile giriş hatası: " + e.toString());
      return null;
    }
  }
}
