import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:starlight_credits/controller/base_view_controller.dart';
import 'package:starlight_credits/view/register_view.dart';
import 'package:starlight_credits/util/string_util.dart';
import 'package:starlight_credits/util/ui_util.dart';

import '../db/firestore_handler.dart';
import '../util/notification_util.dart';

class HomeController extends BaseViewController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _validateLoginInput(String email, String password) {
    if (StringUtil.isAnyEmpty([email, password])) {
      NotificationUtil.showErrorSnackBarMessage(context, 'Both email and password are required.');
      return false;
    }
    return true;
  }

  Future<void> handleRegisterClick() async {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const RegisterViewStateful()));
  }

  Future<void> handleLoginClick() async {
    String email = emailController.value.text;
    String password = passwordController.value.text;

    if (!_validateLoginInput(email, password)) {
      return;
    }

    FirestoreHandler fsHandler = await FirestoreHandler.getInstance();
    User? user = await fsHandler.getUsersHandler().tryLoginUser(email, password);

    if (user == null) {
      NotificationUtil.showErrorSnackBarMessage(context, 'Invalid credentials, please try again.');
      return;
    }

    UiUtil.restoreFocus();
    NotificationUtil.showSuccessSnackBarMessage(context, 'Welcome back, ${user.email!}!');
  }
}
