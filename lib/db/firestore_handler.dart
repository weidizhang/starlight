import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight_credits/db/data_users.dart';
import 'package:starlight_credits/db/data_tx.dart';
import '../firebase_options.dart';

class FirestoreHandler {
  late DataUsers _users;
  late DataTx _tx;

  static late FirestoreHandler instance;
  static bool isInit = false;

  Future<void> init() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    _users = DataUsers(FirebaseFirestore.instance.collection('users'));
    _tx = DataTx(FirebaseFirestore.instance.collection('transactions'));
  }

  DataUsers getUsersHandler() {
    return _users;
  }

  DataTx getTxHandler() {
    return _tx;
  }

  static Future<FirestoreHandler> getInstance() async {
    // A very crudely done singleton.
    if (!isInit) {
      instance = FirestoreHandler();
      await instance.init();
      isInit = true;
    }
    return instance;
  }
}
