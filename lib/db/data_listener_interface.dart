import 'dart:async';

abstract class DataListenerInterface {
  void registerGlobalListener();

  Future<void> unregisterGlobalListener();
}
