import 'package:docs/variables/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileCircleAvatar extends StatelessWidget {
  const ProfileCircleAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 12.h,
                child: Icon(
                  Icons.person,
                  size: 8.h,
                ),
              ),
            ],
          ),
          Text(
            "User Name",
            style: TextStyles.userNameTextStyle,
          ),
          Text(
            "certification",
            style: TextStyles.detailsTextStyle,
          ),
          Text(
            "Patients : 5",
            style: TextStyles.detailsTextStyle,
          ),
          Divider()
        ],
      ),
    );
  }
}
