import 'package:flutter/cupertino.dart';

class SearchDocController extends ChangeNotifier {
  bool search = false;
  setSearch(bool t) {
    if (search != t) {
      search = t;
      notifyListeners();
    }
  }
}
