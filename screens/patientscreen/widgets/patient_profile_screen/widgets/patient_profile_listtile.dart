import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../model/patient.dart';

class PatientProfieListTile extends StatelessWidget {
  const PatientProfieListTile({
    Key? key,
    required this.title,
    required this.trailing,
    required this.editFunction,
    required this.access,
  }) : super(key: key);
  final String? title;
  final String? trailing;
  final bool access;
  final Function? editFunction;
  @override
  Widget build(BuildContext context) {
    final patient = Provider.of<Patient>(context);
    return ListTile(
      leading: access
          ? IconButton(
              onPressed: (editFunction == null) ? null : () => editFunction!(),
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            )
          : null,
      title: Text(
        (title != null) ? title as String : '',
        style: Theme.of(context).textTheme.headline2,
      ),
      trailing: Text(
        (trailing != null) ? trailing as String : '',
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }
}
