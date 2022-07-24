import 'package:docs/screens/profile_screen/profile_screen.dart';
import 'package:docs/variables/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DrawerProfileAvatar extends StatelessWidget {
  const DrawerProfileAvatar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Column(
        children: [
          CircleAvatar(
            radius: 8.h,
            child: Icon(
              Icons.person,
              size: 6.h,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "User Name",
            style: TextStyles.userNameTextStyle,
          ),
          const SizedBox(
            height: 8,
          ),
          TextButton(
            onPressed: () => openProfileBehaviour(context),
            child: const Text('Show Profile'),
          )
        ],
      ),
    );
  }

  openProfileBehaviour(BuildContext context) {
    Scaffold.of(context).closeDrawer();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfileScreen(),
      ),
    );
  }
}
