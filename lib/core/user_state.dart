import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserState {
  User user;
  DocumentSnapshot userDoc;
  List<DocumentSnapshot> txDocs;

  UserState(this.user, this.userDoc, this.txDocs);
}
