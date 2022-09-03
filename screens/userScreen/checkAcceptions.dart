import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth.dart';
import '../../model/user.dart';

import '../../screens/guestscreen/guestscreen.dart';
import '../../screens/splashscreen/splashscreen.dart';
import '../../screens/userScreen/UserScreenAccepted.dart';
import '../../screens/userScreen/widgets/loadingIndicator.dart';

import '../../model/role_provider.dart';

class CheckAcception extends StatelessWidget {
  CheckAcception({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder<bool>(
          future: curentUser.getDataFromApi(),
          builder: (context, snaps) {
            if (snaps.connectionState == ConnectionState.waiting) {
              print('loading getUserData');
              return LoadingIndicator(
                label: 'تحميل الداتا',
                postion: 2,
              );
            }
            if (snaps.data == true) {
              return StreamBuilder(
                stream: FirebaseDatabase.instance
                    .ref()
                    .child('activation')
                    .child(curentUser.id as String)
                    .child('accepted')
                    .onValue,
                builder: (ct, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    print('loading activation');
                    return LoadingIndicator(
                      label: 'التفعيل',
                      postion: 3,
                    );
                  }
                  if (snap.data != null) {
                    if ((snap.data as DatabaseEvent).snapshot.exists) {
                      bool accepted =
                          (snap.data as DatabaseEvent).snapshot.value as bool;
                      curentUser.accepted = accepted;
                      if (accepted) {
                        return StreamBuilder<DatabaseEvent>(
                            stream: FirebaseDatabase.instance
                                .ref()
                                .child('users')
                                .child(curentUser.id as String)
                                .child('role')
                                .onValue,
                            builder: (context, snapshotRole) {
                              if (snapshotRole.connectionState ==
                                  ConnectionState.waiting) {
                                print('loading role');
                                return LoadingIndicator(
                                  label: 'البحث عن الدور',
                                  postion: 4,
                                );
                                ;
                              }
                              if (snapshotRole.data != null) if (snapshotRole
                                      .data!.snapshot.value !=
                                  null) {
                                roleProvider.setRole(snapshotRole
                                    .data!.snapshot.value as String);

                                return UserScreen();
                              }

                              return Scaffold(
                                body: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'حدث خطأ تواصل مع مسؤول الملف',
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 20),
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            FirebaseAuth.instance.signOut();
                                          },
                                          child: Text('تسجيل خروج'))
                                    ],
                                  ),
                                ),
                              );
                            });
                      }

                      return Scaffold(
                        body: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  'هذا الايميل ليست مفعلة الرجاء التوجه لمسؤول الملف'),
                              TextButton(
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                },
                                child: Text("خروج"),
                              ),
                            ],
                          ),
                        ),
                      );
                      // else {
                      //   return GuestScreen(true);
                      // }
                    }
                  }

                  return Scaffold(
                    body: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('حدث خطأ'),
                          TextButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                            },
                            child: Text("خروج"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return Scaffold(
              body: Center(
                child: Dialog(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('حدث خطأ اثناء تحميل الداتا الرجاء مراجعة المطور'),
                        ElevatedButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                            },
                            child: Text('حاول مجددا'))
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
