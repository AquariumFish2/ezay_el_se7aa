import 'package:flutter/cupertino.dart';

class NormalPostProvider extends ChangeNotifier {
  int indexVision = 0;
  void setIndexVision(int val) {
    indexVision = val;
    notifyListeners();
  }

  void addOne() {
    indexVision++;
    notifyListeners();
  }
}
