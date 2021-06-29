import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AppUser with ChangeNotifier {
  String id;
  String name;
  String photoUrl;
  String email;
  String password;
  DateTime creationDate;

  AppUser({
    @required this.id,
    @required this.name,
    @required this.photoUrl,
    @required this.email,
    @required this.password,
    @required this.creationDate,
  });

  factory AppUser.userFromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data();

    return AppUser(
      id: doc.id,
      name: data['name'],
      photoUrl: data['profilePhotoUrl'],
      email: data['email'],
      creationDate: data['creationDate'],
      password: null,
    );
  }

  Map<String, dynamic> get mapFromUser {
    return {
      'id': this.id,
      'name': this.name,
      'profilePhotoUrl': this.photoUrl,
      'email': this.email,
      'creationDate': this.creationDate,
    };
  }
}
