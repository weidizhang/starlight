import 'package:flutter/material.dart';
import 'package:starlight_credits/core/app_constants.dart';
import 'package:starlight_credits/core/globals.dart';
import 'package:starlight_credits/db/firebase_listeners.dart';
import 'package:starlight_credits/db/firestore_handler.dart';
import 'package:starlight_credits/view/home_view.dart';

void main() async {
  runApp(const StarlightApp());

  FirestoreHandler fsHandler = await FirestoreHandler.getInstance();
  await fsHandler.init();
  await fsHandler.getUsersHandler().signOutAuthedUser();

  FirebaseListeners.init();
}

class StarlightApp extends StatelessWidget {
  const StarlightApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeViewStateful(),
      navigatorKey: Globals.navState,
    );
  }
}
