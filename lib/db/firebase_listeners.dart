import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:starlight_credits/core/globals.dart';
import 'package:starlight_credits/db/firestore_handler.dart';
import 'package:starlight_credits/util/ui_util.dart';
import 'package:starlight_credits/view/home_view.dart';
import 'package:starlight_credits/view/user_view.dart';

import '../core/user_state.dart';

class FirebaseListeners {
  static Future<void> handleSignedOutFlow() async {
    FirestoreHandler fsHandler = await FirestoreHandler.getInstance();
    fsHandler.getUsersHandler().unregisterGlobalListener();
    fsHandler.getTxHandler().unregisterGlobalListener();

    Globals.setUserState(null);
    UiUtil.restoreFocus();
    UiUtil.navigateToView(const HomeViewStateful());
  }

  static Future<void> handleSignedInFlow(User user) async {
    FirestoreHandler fsHandler = await FirestoreHandler.getInstance();
    DocumentSnapshot? userDoc = await fsHandler.getUsersHandler().getDocByUid(user.uid);
    if (userDoc == null) {
      throw Exception('No user doc when logged in.');
    }

    List<DocumentSnapshot> txDocs = await fsHandler.getTxHandler().getDocByUid(user.uid);
    Globals.setUserState(UserState(user, userDoc, txDocs));
    fsHandler.getUsersHandler().registerGlobalListener();
    fsHandler.getTxHandler().registerGlobalListener();

    UiUtil.restoreFocus();
    UiUtil.navigateToView(const UserViewStateful());
  }

  static void init() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        await handleSignedOutFlow();
      } else {
        await handleSignedInFlow(user);
      }
    });
  }
}
