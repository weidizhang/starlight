import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight_credits/core/globals.dart';
import 'package:starlight_credits/db/data_listener_interface.dart';
import 'package:starlight_credits/util/ui_util.dart';

class DataUsers implements DataListenerInterface {
  CollectionReference users;
  StreamSubscription? globalListener;

  DataUsers(this.users);

  @override
  void registerGlobalListener() {
    globalListener = users.where('uid', isEqualTo: Globals.getUserState().user.uid)
      .snapshots()
      .listen((querySnapshot) {
        DocumentSnapshot latestUserDoc = querySnapshot.docChanges.last.doc;
        Globals.getUserState().userDoc = latestUserDoc;
        UiUtil.refreshView();
      });
  }

  @override
  Future<void> unregisterGlobalListener() async {
    await globalListener?.cancel();
  }

  User getAuthedUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Called getCurrentAuthedUser without auth.');
    }
    return user;
  }

  Future<void> signOutAuthedUser() {
    return FirebaseAuth.instance.signOut();
  }

  Future<User?> createUser(String email, String username, String password) async {
    // Prevent duplicate usernames.
    DocumentSnapshot userDoc = await getDocByUsername(username);
    if (userDoc.exists) {
      return null;
    }

    // Prevent duplicate emails.
    User? user;
    try {
      user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => value.user);
    } on FirebaseAuthException catch (e) {
      return null;
    }

    if (user == null) {
      return null;
    }

    // Create initial user doc if registration was successful.
    await users.doc(username).set({
      'email': email,
      'uid': user.uid,
      'balanceCents': 0,
      'lastTxId': '',
    });
    return user;
  }

  Future<User?> tryLoginUser(String email, String password) async {
    try {
      return await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => value.user);
    } on FirebaseAuthException catch (_) {
      return null;
    }
  }

  Future<DocumentSnapshot> getDocByUsername(String username) {
    return users.doc(username).get();
  }

  DocumentReference getDocRefByUsername(String username) {
    return users.doc(username);
  }

  Future<DocumentSnapshot?> getDocByUid(String uid) async {
    QuerySnapshot qs = await users.where('uid', isEqualTo: uid).get();
    if (qs.size != 1) {
      return null;
    }
    return qs.docs.first;
  }

  Future<bool> checkSufficientBalance(String username, int amountCents) async {
    DocumentSnapshot doc = await getDocByUsername(username);
    if (!doc.exists) {
      return false;
    }

    int balanceCents = doc.get('balanceCents');
    return balanceCents >= amountCents;
  }
}
