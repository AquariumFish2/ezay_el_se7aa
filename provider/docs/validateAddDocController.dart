import 'package:flutter/cupertino.dart';

class ValidateAddDocController extends ChangeNotifier {
  bool validate = false;
  String? classification;
  setClassification(String value) {
    classification = value;
    notifyListeners();
  }

  bool tryToValidate() {
    if (classification != null) return true;
    validate = true;
    notifyListeners();
    return false;
  }
}
