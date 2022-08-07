import 'package:flutter/cupertino.dart';

class LoginController extends ChangeNotifier {
  bool _newUser = false;

  bool get newUSer => _newUser;

  void togleNewUSer() {
    _newUser = !_newUser;
    notifyListeners();
  }
}
