import 'package:flutter/cupertino.dart';

class SwitchAddDocController extends ChangeNotifier {
  bool value = false;
  togleValue() {
    value = !value;
    notifyListeners();
  }
}
