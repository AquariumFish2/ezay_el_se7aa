import 'package:flutter/cupertino.dart';

class RoleLoginController extends ChangeNotifier {
  String? role;
  List<String> roleItems = [
    'مسؤول الاستقبال',
    'مسؤول الميديا',
    'مسؤول الشراكات',
    'متطوع'
  ];
  setRole(String value) {
    role = value;
    notifyListeners();
  }
}
