import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String userName;

  User(this.userName);

  void setUserName(String newUserName) {
    userName = newUserName;
    notifyListeners();
  }
}
