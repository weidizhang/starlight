import 'package:flutter/material.dart';

import '../core/globals.dart';

class UiUtil {
  static void restoreFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static void navigateToView(Widget widget) {
    Navigator.pushReplacement(
      Globals.getContextFromGlobalState(),
      MaterialPageRoute(builder: (context) {
        return widget;
      }),
    );
  }

  // Horrible hack to refresh current view.
  static void refreshView() {
    BuildContext context = Globals.getContextFromGlobalState();
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    Element el = context as Element;
    el.markNeedsBuild();
    el.visitChildren(rebuild);
  }
}
