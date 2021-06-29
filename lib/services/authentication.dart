import 'package:firebase_auth/firebase_auth.dart';

import './users.dart';
import '../providers/appUser.dart';

class Authentication {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// returns a stream of [User] to check if the user signed in/out.
  static Stream<User> get onAuthStateChanged {
    return _auth.authStateChanges();
  }

  /// returns the current user [id].
  ///
  /// null if there is no signed in user.
  static String get currentUserId {
    return _auth.currentUser.uid;
  }

  /// a mehtod to send a reset password email
  static Future<dynamic> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      print('ERROR: ${e.toString()} in sendPasswordResetEmail');
      return e;
    }
  }

  /// signs a user in using his email and password.
  ///
  /// may returns 'FirebaseAuthException'.
  ///
  /// returns null when everything is ok.
  static Future<dynamic> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!result.user.emailVerified) await result.user.sendEmailVerification();

      return null;
    } catch (e) {
      print('ERROR: ${e.toString()} in signInWithEmailAndPassword');
      return e;
    }
  }

  /// create a new user using his email and password.
  /// then saves all user's data to firestore.
  static Future<dynamic> createUserWithEmailAndPassword(AppUser user) async {
    try {
      UserCredential result = await _auth
          .createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      )
          .then((value) {
        value.user.updateDisplayName(user.name);
        value.user.updatePhotoURL(user.photoUrl);

        return value;
      });

      await UsersServices.addUserToCloud(result, user);
      await result.user.sendEmailVerification();

      return null;
    } catch (e) {
      print('ERROR: ${e.toString()} in createUserWithEmailAndPassword');
      return e;
    }
  }

  /// signs a user out.
  static Future<dynamic> signOut() async {
    try {
      await _auth.signOut();
      return null;
    } catch (e) {
      print('ERROR: ${e.toString()} in signOut');
      return e;
    }
  }
}
