import 'package:flutter/cupertino.dart';

class CheckBoxAddDocController extends ChangeNotifier {
  bool value = false;
  toggleValue() {
    value = !value;
    notifyListeners();
  }
}
