import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:starlight_credits/view/profile_view.dart';
import 'package:starlight_credits/view/send_funds_view.dart';
import 'package:starlight_credits/view/tx_view.dart';

import '../core/app_constants.dart';

class UserViewStateful extends StatefulWidget {
  const UserViewStateful({Key? key}) : super(key: key);

  @override
  State<UserViewStateful> createState() => UserView();
}

class UserNavItem {
  Widget Function() viewCreator;
  Icon icon;
  String name;
  String screenType;

  UserNavItem(this.viewCreator, this.icon, this.name, this.screenType);
}

class UserView extends State<UserViewStateful> {
  final List<dynamic> _navBarItems = [
    UserNavItem(
      () => const TransactionViewStateful(),
      const Icon(Icons.attach_money_sharp),
      'Transactions',
      AppConstants.screenTransactions,
    ),
    UserNavItem(
      () => const SendFundsViewStateful(),
      const Icon(Icons.send),
      'Send Funds',
      AppConstants.screenSendFunds,
    ),
    UserNavItem (
      () => const ProfileViewStateful(),
      const Icon(Icons.person),
      'Profile',
      AppConstants.screenProfile,
    ),
  ];
  int _selectedIndex = 0;
  User? user;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String getCurrentTitle() {
    return _navBarItems[_selectedIndex].name;
  }

  Widget getCurrentWidget() {
    return _navBarItems[_selectedIndex].viewCreator();
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> bottomNavBarItems = [];
    Map<int, dynamic> navBarItemsMap = _navBarItems.asMap();
    for (int i = 0; i < navBarItemsMap.length; ++i) {
      dynamic item = navBarItemsMap[i];
      bottomNavBarItems.add(
        BottomNavigationBarItem(icon: item.icon, label: item.name)
      );
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(title: Text(getCurrentTitle())),
        body: getCurrentWidget(),
        bottomNavigationBar: BottomNavigationBar(
          items: bottomNavBarItems,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
