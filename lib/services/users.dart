import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/appUser.dart';
import './references.dart';

class UsersServices {
  /// takes info of the user who just created an account [result],
  /// and user object (contains input info) [user],
  /// and stores the user in Firestore.
  static Future<void> addUserToCloud(
    UserCredential result,
    AppUser user,
  ) async {
    user.id = result.user.uid;

    try {
      await References.users.doc(result.user.uid).set(user.mapFromUser);
    } catch (e) {
      print('ERROR:::: ${e.toString()} in addUserToCloud');
    }
  }

  /// returns a single users from the database.
  ///
  /// when an error occurs, it returns null.
  static Future<AppUser> getSingleUser(String userId) async {
    DocumentSnapshot userDoc;
    AppUser user;

    try {
      userDoc = await References.users.doc(userId).get();
      user = AppUser.userFromDocumentSnapshot(userDoc);

      return user;
    } catch (e) {
      print('ERROR: ${e.toString()} in getSingleUser');

      return null;
    }
  }

  /// returns a list of all users from the database.
  ///
  /// when an error occurs, it returns null.
  static Future<List<AppUser>> get getAllUsers async {
    try {
      QuerySnapshot snapshot = await References.users.get();

      List<AppUser> users = snapshot.docs.map((doc) {
        return AppUser.userFromDocumentSnapshot(doc);
      }).toList();

      return users;
    } catch (e) {
      print('ERROR: ${e.toString()} in Future<List<AppUser>>');

      return null;
    }
  }
}
