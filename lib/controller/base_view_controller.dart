import 'package:flutter/material.dart';

class BaseViewController {
  late BuildContext context;

  void updateContext(BuildContext context) {
    this.context = context;
  }
}
