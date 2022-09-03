import 'package:flutter/cupertino.dart';

class BottomNavigationController extends ChangeNotifier {
  int index = 0;

  setIndex(int i) {
    index = i;
    notifyListeners();
  }
}
