import 'package:flutter/cupertino.dart';

class CityLoginController extends ChangeNotifier {
  String? city;
  List<String> cityItems = [
    'بنها',
    'طوخ',
    'قليوب',
    'شبين',
    'الخانكة',
  ];
  setCity(String value) {
    city = value;
    notifyListeners();
  }
}
