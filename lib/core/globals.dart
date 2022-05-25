import 'package:flutter/material.dart';
import 'package:starlight_credits/core/user_state.dart';

class Globals {
  static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
  static UserState? _userState;

  static BuildContext getContextFromGlobalState() {
    BuildContext? context = navState.currentContext;
    if (context == null) {
      throw Exception('No context available.');
    }
    return context;
  }

  static Widget getWidgetFromGlobalState() {
    Widget? widget = navState.currentWidget;
    if (widget == null) {
      throw Exception('No widget available.');
    }
    return widget;
  }

  static void setUserState(UserState? userState) {
    _userState = userState;
  }

  static UserState? getUserStateSafe() {
    return _userState;
  }

  static UserState getUserState() {
    if (_userState == null) {
      throw Exception('Tried to obtain user state in bad path.');
    }
    return _userState!;
  }
}
