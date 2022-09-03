import 'package:flutter/cupertino.dart';

class ExpandDocSample extends ChangeNotifier {
  bool expand = false;
  setExpand() {
    expand = !expand;
    notifyListeners();
  }
}
