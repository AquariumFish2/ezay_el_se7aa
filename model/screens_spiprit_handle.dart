import 'package:flutter/material.dart';

import '../helpers/docicon.dart';

enum ScreensTypes {
  Pos,
  DocsResposible,
  searchResponsible,
  normal,
}

enum Pages {
  docsScreen,
  SearchScreen,
  PostsScreen,
  VolanteersScreen,
  ProfileScreen,
}

ScreensSipritHandle screensSipritHandle = ScreensSipritHandle();

class ScreensSipritHandle {
  List<Pages> determinedScreens = [
    Pages.docsScreen,
    Pages.SearchScreen,
    Pages.PostsScreen,
    Pages.VolanteersScreen,
    Pages.ProfileScreen,
  ];
  setDetreminedScreens(ScreensTypes role) {
    if (role == ScreensTypes.Pos || role == ScreensTypes.DocsResposible)
      determinedScreens = [
        Pages.docsScreen,
        Pages.SearchScreen,
        Pages.PostsScreen,
        Pages.VolanteersScreen,
        Pages.ProfileScreen,
      ];
    else
      determinedScreens = [
        Pages.SearchScreen,
        Pages.PostsScreen,
        Pages.VolanteersScreen,
        Pages.ProfileScreen,
      ];
  }

  Pages getPage(int i) {
    return determinedScreens[i];
  }

  IconData getIcon(Pages page) {
    if (page == Pages.docsScreen)
      return DocIcons.doctor;
    else if (page == Pages.SearchScreen)
      return Icons.notes;
    else if (page == Pages.PostsScreen)
      return Icons.card_giftcard;
    else if (page == Pages.VolanteersScreen)
      return Icons.manage_accounts;
    else
      return Icons.person;
  }

  String getLabel(Pages page) {
    if (page == Pages.docsScreen)
      return 'الدكاترة';
    else if (page == Pages.SearchScreen)
      return 'أبحاث';
    else if (page == Pages.PostsScreen)
      return 'البوستات';
    else if (page == Pages.VolanteersScreen)
      return 'المتطوعين';
    else
      return 'الأكونت';
  }
}
