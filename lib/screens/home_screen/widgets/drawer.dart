import 'package:docs/screens/home_screen/widgets/custom_divider.dart';
import 'package:docs/screens/home_screen/widgets/widgets/drawer_list_tile.dart';
import 'package:docs/screens/home_screen/widgets/widgets/drawer_profile_avatar.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [
          DrawerProfileAvatar(),
          CustomDivider(),
          DrawerListTile(title: 'Volanteers Details',),
          CustomDivider(),
          DrawerListTile(title: 'My Patients'),
          CustomDivider(),
          DrawerListTile(title: 'Statics'),
          CustomDivider(),
          DrawerListTile(title: 'Available Doctors'),
        ],
      ),
    );
  }
}
