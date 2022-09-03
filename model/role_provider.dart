import 'package:flutter/cupertino.dart';
import '../model/screens_spiprit_handle.dart';

RoleModel roleProvider = RoleModel();

class RoleModel {
  ScreensTypes? role;
  bool firstSetRole = false;
  setRole(String newRole) {
    if (newRole == 'مسؤول الملف')
      role = ScreensTypes.Pos;
    else if (newRole == 'مسؤول الدكاترة')
      role = ScreensTypes.DocsResposible;
    else if (newRole == 'مسؤول الأبحاث')
      role = ScreensTypes.searchResponsible;
    else
      role = ScreensTypes.normal;

    screensSipritHandle.setDetreminedScreens(role as ScreensTypes);
  }

  ScreensTypes getRole(String newRole) {
    if (newRole == 'مسؤول الملف')
      return ScreensTypes.Pos;
    else if (newRole == 'مسؤول الدكاترة')
      return ScreensTypes.DocsResposible;
    else if (newRole == 'مسؤول الأبحاث')
      return ScreensTypes.searchResponsible;
    else
      return ScreensTypes.normal;
  }

  String toStringRole(ScreensTypes role) {
    if (role == ScreensTypes.Pos)
      return 'مسؤول الملف';
    else if (role == ScreensTypes.DocsResposible)
      return 'مسؤول الداكترة';
    else if (role == ScreensTypes.searchResponsible)
      return 'مسؤول الابحاث';
    else
      return 'متطوع';
  }
}
