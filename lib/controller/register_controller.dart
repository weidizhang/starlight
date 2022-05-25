import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:starlight_credits/controller/base_view_controller.dart';
import 'package:starlight_credits/util/notification_util.dart';
import 'package:starlight_credits/util/string_util.dart';

import '../db/firestore_handler.dart';

class RegisterController extends BaseViewController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _validateJoinInput(
    String email, String username, String password, String confirmPassword,
  ) {
    if (StringUtil.isAnyEmpty([email, username, password, confirmPassword])) {
      NotificationUtil.showErrorSnackBarMessage(context, 'All fields must be filled out.');
      return false;
    }
    if (password != confirmPassword) {
      NotificationUtil.showErrorSnackBarMessage(context, 'Oops! Your passwords don\'t match.');
      return false;
    }
    if (password.length < 6) {
      NotificationUtil.showErrorSnackBarMessage(context, 'Oops! Your password needs to be at least 6 characters.');
    }
    return true;
  }

  Future<void> handleJoinClick() async {
    String email = emailController.value.text;
    String username = usernameController.value.text;
    String password = passwordController.value.text;
    String confirmPassword = confirmPasswordController.value.text;

    if (!_validateJoinInput(email, username, password, confirmPassword)) {
      return;
    }

    FirestoreHandler fsHandler = await FirestoreHandler.getInstance();
    User? user = await fsHandler.getUsersHandler().createUser(email, username, password);

    if (user == null) {
      NotificationUtil.showErrorSnackBarMessage(context, 'Your email or username is already in use.');
      return;
    }

    NotificationUtil.showSuccessSnackBarMessage(context, 'Success! Your new account is ready.');
  }
}
