import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../helpers/data_lists.dart';
import '../../../provider/bottom_navigationController.dart';
import '../../../provider/patients/patients.dart';
import '../../../model/volanteer.dart';
import '../../../screens/volscreen/volprofilescreen.dart';

import '../../../model/screens_spiprit_handle.dart';
import '../../../model/role_provider.dart';

// ignore: must_be_immutable
class VolListTile extends StatelessWidget {
  VolListTile({Key? key, required this.volanteer}) : super(key: key);
  final Volanteer volanteer;

  Widget build(BuildContext context) {
    final patients = Provider.of<PatientsProv>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: (volanteer.accepted as bool)
              ? Colors.blue.shade300
              : Colors.red[300],
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(value: patients),
                  ],
                  child: Consumer<BottomNavigationController>(
                    builder: (context, value, child) =>
                        VolanteerProfileScreen(volanteer, true),
                  ),
                ),
              ),
            );
          },
          leading: (roleProvider.role == ScreensTypes.Pos &&
                  volanteer.role != ScreensTypes.Pos)
              ? IconButton(
                  onPressed: () async {
                    await FirebaseDatabase.instance
                        .ref()
                        .child("activation")
                        .child(volanteer.id as String)
                        .update({"accepted": !(volanteer.accepted as bool)});
                    context.read<BottomNavigationController>().setIndex(
                        context.watch<BottomNavigationController>().index);
                  },
                  icon: (volanteer.accepted as bool)
                      ? Icon(
                          Icons.check_box,
                          color: Colors.green,
                        )
                      : Icon(
                          Icons.check_box_outline_blank,
                          color: Colors.white,
                        ),
                )
              : null,
          title: Column(
            children: [
              Text(
                volanteer.name as String,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          trailing: FittedBox(
            child: Text(
              volanteer.phone as String,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
