import 'package:flutter/cupertino.dart';

class SpecLoginController extends ChangeNotifier {
  String? spec;
  setSpec(String val) {
    spec = val;
    notifyListeners();
  }
}
