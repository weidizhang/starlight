import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight_credits/util/notification_util.dart';
import 'package:uuid/uuid.dart';

import 'package:starlight_credits/db/firestore_handler.dart';

import '../core/globals.dart';
import 'data_listener_interface.dart';

class DataTx implements DataListenerInterface {
  CollectionReference txs;
  StreamSubscription? globalListenerFrom;
  StreamSubscription? globalListenerTo;

  DataTx(this.txs);

  @override
  void registerGlobalListener() {
    String uid = Globals.getUserState().user.uid;

    snapshotCb(querySnapshot) async {
      // Fetches all transactions again if we detect any change.
      // A very lazy implementation.
      FirestoreHandler fsHandler = await FirestoreHandler.getInstance();
      List<DocumentSnapshot> txDocs = await fsHandler.getTxHandler()
          .getDocByUid(uid);
      List<DocumentSnapshot> oldTxDocs = Globals.getUserState().txDocs;
      Globals.getUserState().txDocs = txDocs;

      // Check most recent doc and see if current user is on the receiving end.
      if (
        txDocs.isNotEmpty && txDocs[0].get('toUid') == uid &&
        (oldTxDocs.isEmpty || oldTxDocs[0].id != txDocs[0].id)
      ) {
        NotificationUtil.showSuccessSnackBarMessage(
          Globals.getContextFromGlobalState(),
          'You received funds from ${txDocs[0].get('fromUsername')}!',
        );
      }
    }

    globalListenerFrom = txs.where('fromUid', isEqualTo: uid)
      .snapshots()
      .listen(snapshotCb);
    globalListenerTo = txs.where('toUid', isEqualTo: uid)
      .snapshots()
      .listen(snapshotCb);
  }

  @override
  Future<void> unregisterGlobalListener() async {
    await globalListenerFrom?.cancel();
    await globalListenerTo?.cancel();
  }

  Future<void> commitTransfer(User fromUser, String toUserUsername, int amountCents) async {
    FirestoreHandler fsHandler = await FirestoreHandler.getInstance();

    DocumentSnapshot? fromUserDoc = await fsHandler.getUsersHandler().getDocByUid(fromUser.uid);
    if (fromUserDoc == null || !fromUserDoc.exists) {
      return Future.error('Error fetching information about current user.');
    }

    String txId = const Uuid().v4();

    DocumentReference txDocRef = txs.doc(txId);
    DocumentReference fromUserDocRef = fsHandler.getUsersHandler()
        .getDocRefByUsername(fromUserDoc.id);
    DocumentReference toUserDocRef = fsHandler.getUsersHandler()
        .getDocRefByUsername(toUserUsername);

    Future<void> doTransfer(Transaction transaction) async {
      DocumentSnapshot fromUserDoc = await transaction.get(fromUserDocRef);
      DocumentSnapshot toUserDoc = await transaction.get(toUserDocRef);

      transaction.set(txDocRef, {
        'fromUsername': fromUserDoc.id,
        'fromUid': fromUserDoc.get('uid'),
        'toUsername': toUserUsername,
        'toUid': toUserDoc.get('uid'),
        'amountCents': amountCents,
        'timestamp': Timestamp.now(),
      });

      int newFromUserBalanceCents = fromUserDoc.get('balanceCents') - amountCents;
      int newToUserBalanceCents = toUserDoc.get('balanceCents') + amountCents;

      transaction.update(fromUserDocRef, {
        'balanceCents': newFromUserBalanceCents,
        'lastTxId': txId,
      });
      transaction.update(toUserDocRef, {
        'balanceCents': newToUserBalanceCents,
        'lastTxId': txId,
      });
    }

    return FirebaseFirestore.instance.runTransaction(doTransfer);
  }

  Future<List<DocumentSnapshot>> getDocByUid(String uid) async {
    List<DocumentSnapshot> merged = [
      ...await _getDocByFromUid(uid),
      ...await _getDocByToUid(uid),
    ];
    merged.sort((a, b) => (b.get('timestamp') as Timestamp)
        .compareTo((a.get('timestamp')) as Timestamp));
    return merged;
  }

  Future<List<DocumentSnapshot>> _getDocByFromUid(String uid) async {
    QuerySnapshot qs = await txs.where('fromUid', isEqualTo: uid).get();
    return qs.docs;
  }

  Future<List<DocumentSnapshot>> _getDocByToUid(String uid) async {
    QuerySnapshot qs = await txs.where('toUid', isEqualTo: uid).get();
    return qs.docs;
  }
}
