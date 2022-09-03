import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../screens/authscreen/authscreen.dart';

class CheckFirstEmailBeforeAuth extends StatelessWidget {
  const CheckFirstEmailBeforeAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<DataSnapshot> checkIfUsersExist() async {
      DataSnapshot checked;
      checked = await FirebaseDatabase.instance
          .ref()
          .child('activation')
          .get()
          .catchError((error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error)));
      });

      return checked;
    }

    return FutureBuilder(
        future: checkIfUsersExist(),
        builder: (context, snap) {
          if (snap.hasData) {
            if (snap.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            bool checked = false;
            if ((snap.data as DataSnapshot).exists || snap.data != null) {
              checked = true;
            }
            return AuthScreen(checked);
          }
          return AuthScreen(false);
        });
  }
}
