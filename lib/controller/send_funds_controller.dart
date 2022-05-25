import 'package:flutter/material.dart';
import 'package:starlight_credits/controller/base_view_controller.dart';
import 'package:starlight_credits/core/globals.dart';
import 'package:starlight_credits/db/firestore_handler.dart';
import 'package:starlight_credits/util/notification_util.dart';
import 'package:starlight_credits/util/string_util.dart';
import 'package:starlight_credits/util/ui_util.dart';

class SendFundsController extends BaseViewController {
  final TextEditingController recipientController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  bool _validateSendInput(String recipient, int amountCents) {
    if (StringUtil.isEmpty(recipient)) {
      NotificationUtil.showErrorSnackBarMessage(context, 'Recipient cannot be empty.');
      return false;
    }
    if (amountCents <= 0) {
      NotificationUtil.showErrorSnackBarMessage(context, 'Invalid amount to send.');
      return false;
    }
    if (recipient == Globals.getUserState().userDoc.id) {
      NotificationUtil.showErrorSnackBarMessage(context, 'Cannot send funds to yourself.');
      return false;
    }
    if (amountCents > Globals.getUserState().userDoc.get('balanceCents')) {
      NotificationUtil.showErrorSnackBarMessage(context, 'Insufficient funds.');
      return false;
    }
    return true;
  }

  Future<void> handleSendClick() async {
    String recipient = recipientController.value.text;
    double amount = double.tryParse(amountController.value.text) ?? 0.0;
    int amountCents = (amount * 100).toInt();

    if (!_validateSendInput(recipient, amountCents)) {
      return;
    }

    FirestoreHandler fsHandler = await FirestoreHandler.getInstance();
    await fsHandler.getTxHandler().commitTransfer(
      Globals.getUserState().user,
      recipient,
      amountCents,
    );

    UiUtil.restoreFocus();
    NotificationUtil.showSuccessSnackBarMessage(context, 'Your transfer to $recipient was successful.');
    recipientController.clear();
    amountController.clear();
  }
}
