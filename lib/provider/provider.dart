import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  dynamic snapshot;


  void updateFirstSnapshot(dynamic newSnapshot) {
    snapshot = newSnapshot;
    notifyListeners();
  }

}
