import 'package:cloud_firestore/cloud_firestore.dart';

// all needed firebase firestore references are listed here

class References {
  static final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
}
