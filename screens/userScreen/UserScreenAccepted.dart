import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/screens_spiprit_handle.dart';
import '../../model/user.dart';
import '../../provider/bottom_navigationController.dart';
import '../../model/role_provider.dart';
import '../../screens/docscreen/getDoctorsData.dart';
import '../../screens/patientscreen/patientScreen.dart';
import '../../screens/postscreen/getPostsScreen.dart';
import '../../screens/volscreen/volprofilescreen.dart';
import '../../screens/volscreen/volscreen.dart';

import '../../model/volanteer.dart';

class UserScreen extends StatelessWidget {
  UserScreen({
    Key? key,
  }) : super(key: key);
  //bool once = true;
  //int i = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<BottomNavigationController>(
          builder: (context, indexcontroller, child) =>
              SelectedPage(screensSipritHandle.getPage(indexcontroller.index)),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.white,
          backgroundColor: Colors.green,
          items: screensSipritHandle.determinedScreens
              .map((e) => BottomNavigationBarItem(
                  icon: Icon(screensSipritHandle.getIcon(e)),
                  label: screensSipritHandle.getLabel(e)))
              .toList(),
          currentIndex: context.watch<BottomNavigationController>().index,
          onTap: (v) {
            context.read<BottomNavigationController>().setIndex(v);
          },
        ));
  }
}

class SelectedPage extends StatelessWidget {
  const SelectedPage(this.page, {Key? key}) : super(key: key);
  final Pages page;
  @override
  Widget build(BuildContext context) {
    print('build page');
    if (page == Pages.docsScreen)
      return GetDoctorsData();
    else if (page == Pages.SearchScreen)
      return PatientScreen();
    else if (page == Pages.PostsScreen)
      return GetPostsScreen();
    else if (page == Pages.VolanteersScreen)
      return VolScreen();
    else
      return VolanteerProfileScreen(
          Volanteer.withCurrentUser(curentUser), false);
  }
}
