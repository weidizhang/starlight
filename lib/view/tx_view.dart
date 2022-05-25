import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:starlight_credits/core/globals.dart';
import 'package:starlight_credits/util/string_util.dart';

enum TransactionType {
  sent,
  received,
}

class TransactionViewStateful extends StatefulWidget {
  const TransactionViewStateful({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TransactionView();
}

class TransactionView extends State<TransactionViewStateful> {

  String getFormattedBalance() {
    int balanceCents = Globals.getUserState().userDoc.get('balanceCents');
    return StringUtil.formatCentsToDollars(balanceCents);
  }

  List<Card> getTransactionCards() {
    List<Card> cards = [];
    List<DocumentSnapshot> txDocs = Globals.getUserState().txDocs;
    String myUid = Globals.getUserState().user.uid;

    for (DocumentSnapshot doc in txDocs) {
      TransactionType txType = doc.get('fromUid') == myUid
        ? TransactionType.sent
        : TransactionType.received;

      String type = txType == TransactionType.sent ? 'Sent' : 'Received';
      String fromToText = txType == TransactionType.sent ? 'To' : 'From';
      String fromToValue = txType == TransactionType.sent
          ? doc.get('toUsername')
          : doc.get('fromUsername');
      IconData icon = txType == TransactionType.sent
          ? Icons.remove
          : Icons.add;
      Color iconColor = txType == TransactionType.sent
          ? Colors.red
          : Colors.green;

      String timePretty = (doc.get('timestamp') as Timestamp)
          .toDate()
          .toLocal()
          .toString();
      String amount = StringUtil.formatCentsToDollars(doc.get('amountCents'));

      cards.add(
        Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(icon, size: 50, color: iconColor),
              title: Text(
                '$type $amount',
                style: const TextStyle(
                  fontFamily: 'RobotoSlab',
                ),
              ),
              subtitle: Text(
                timePretty +
                    '\n'
                    '$fromToText: $fromToValue',
                style: const TextStyle(
                  fontFamily: 'RobotoSlab',
                ),
              ),
            ),
          ),
        ),
      );
    }

    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(
          color: const Color.fromARGB(201, 175, 234, 255),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                child: Text(
                  'My Balance',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'RobotoSlab',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                child: Text(
                  getFormattedBalance(),
                  style: const TextStyle(
                    fontSize: 26.0,
                    fontFamily: 'RobotoSlab',
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 20,
          thickness: 1,
          indent: 5,
          endIndent: 0,
          color: Colors.black38,
        ),
        ...getTransactionCards(),
      ],
      padding: const EdgeInsets.all(10),
    );
  }
}
