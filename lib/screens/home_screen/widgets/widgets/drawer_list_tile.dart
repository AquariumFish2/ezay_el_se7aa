import 'package:docs/variables/text_styles.dart';
import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({Key? key, required this.title, this.fun})
      : super(key: key);
  final String title;
  final Function(void)? fun;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => fun,
      title: Text(
        title,
        style: TextStyles.drawerListTileTextStyle,
      ),
    );
  }
}
