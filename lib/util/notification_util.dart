import 'package:flutter/material.dart';
import 'package:starlight_credits/core/app_constants.dart';

class NotificationUtil {
  static void showGenericSnackBarMessage(BuildContext context, String msg, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
      ),
    );
  }

  static void showErrorSnackBarMessage(BuildContext context, String msg) {
    showGenericSnackBarMessage(context, msg, color: AppConstants.colorError);
  }

  static void showSuccessSnackBarMessage(BuildContext context, String msg) {
    showGenericSnackBarMessage(context, msg, color: AppConstants.colorSuccess);
  }
}
