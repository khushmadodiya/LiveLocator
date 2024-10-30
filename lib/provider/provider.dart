import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  dynamic snapshot;
  bool homelocationflag =false;

  void updateFirstSnapshot(dynamic newSnapshot) {
    snapshot = newSnapshot;
    notifyListeners();
  }

  void ChangehomelocationFlag(){
    homelocationflag==true?homelocationflag=false:homelocationflag=true;
    notifyListeners();
  }


}

class ControllerProvider with ChangeNotifier{
  final searchUserController = TextEditingController();

  TextEditingController get  _searchUserController=>searchUserController;

  @override
  void dispose() {
    _searchUserController.dispose();
    super.dispose();
  }
}
