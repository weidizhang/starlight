import 'package:flutter/material.dart';
import 'package:starlight_credits/core/globals.dart';
import 'package:starlight_credits/db/firestore_handler.dart';

import '../controller/profile_controller.dart';

class ProfileViewStateful extends StatefulWidget {
  const ProfileViewStateful({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProfileView();
}

class ProfileView extends State<ProfileViewStateful> {
  final ProfileController controller = ProfileController();

  @override
  Widget build(BuildContext context) {
    controller.updateContext(context);
    return ListView(
      children: [
        Card(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                  child: Text(
                    'Username',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'RobotoSlab',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Text(
                    Globals.getUserState().userDoc.id,
                    style: const TextStyle(
                      fontSize: 26.0,
                      fontFamily: 'RobotoSlab',
                    ),
                  ),
                ),
              ]
          ),
        ),
        Card(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                  child: Text(
                    'We will send you notifications at',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'RobotoSlab',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Text(
                    Globals.getUserState().user.email!,
                    style: const TextStyle(
                      fontSize: 26.0,
                      fontFamily: 'RobotoSlab',
                    ),
                  ),
                ),
              ]
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(elevation: 2),
            onPressed: controller.handleSignOutClick,
            child: const Text('Sign out'),
          ),
        ),
      ],
      padding: const EdgeInsets.all(10),
    );
  }
}