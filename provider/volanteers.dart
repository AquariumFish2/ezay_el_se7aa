import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../helpers/data_lists.dart';
import '../model/role_provider.dart';

import '../model/volanteer.dart';

class Volanteers extends ChangeNotifier {
  List<Volanteer> _vols = [];
  List<Volanteer> get vols => _vols;
  bool clicked = true;
  Future<void> refresh(
    BuildContext context,
  ) async {
    if (clicked) {
      clicked = false;
      _vols = [];
      DataSnapshot? users;
      DataSnapshot? activations;
      final database = FirebaseDatabase.instance;
      try {
        users = await database.ref().child("users").get();
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Container(
              height: 200,
              child: Center(child: Text('حدث خطأ يمكنك متابعة مسؤول الملف')),
            ),
          ),
        );
      }

      try {
        activations = await database.ref().child('activation').get();
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Container(
              height: 200,
              child: Center(child: Text('حدث خطأ يمكنك متابعة مسؤول الملف')),
            ),
          ),
        );
      }
      final dataTeamColorRefresh =
          await FirebaseDatabase.instance.ref().child('teams').get();

      if (users!.value != null) {
        final List<Map> data;
        DataSnapshot? patients;
        try {
          patients = await database.ref().child('patients').get();
        } catch (e) {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              child: Container(
                height: 200,
                child: Center(child: Text('حدث خطأ الرجاء ابلاغ مسؤول الملف')),
              ),
            ),
          );
        }

        data = List.generate((users.value as Map).length, (index) {
          Map userDetail = (users!.value as Map).values.elementAt(index);
          String userId = (users.value as Map).keys.elementAt(index);

          String team = (users.value as Map).values.elementAt(index)['team'];
          String role = (users.value as Map).values.elementAt(index)['role'];
          bool accepted = (activations!.value
              as Map)[(users.value as Map).keys.elementAt(index)]['accepted'];
          List<Map> pts = [];
          if (patients!.value != null) {
            pts = List.generate((patients.value as Map).length, (index) {
              if ((patients!.value as Map)
                      .values
                      .elementAt(index)['volanteerId'] ==
                  userId)
                return {
                  'patientId': (patients.value as Map).keys.elementAt(index),
                  'patientName': (patients.value as Map)
                      .values
                      .elementAt(index)['patientName']
                };
              return {};
            });
          }

          pts.removeWhere((element) => element == {});
          return {
            'name': userDetail['userName'],
            'phone': userDetail['phone'],
            'state': userDetail['state'],
            'classification': userDetail['classification'],
            'id': userId,
            'email': userDetail['email'],
            'team': team,
            'accepted': accepted,
            'role': role,
            'patients': pts,
          };
        });

        data.forEach((element) {
          _vols.add(Volanteer()
            ..name = element['name']
            ..state = element['state']
            ..phone = element['phone']
            ..id = element['id']
            ..classification = element['classification']
            ..email = element['email']
            ..team = element['team']
            ..accepted = element['accepted']
            ..role = roleProvider.getRole(element['role'])
            ..patients = element['patients']);
        });
      }
      clicked = true;
    }
  }

  // void addVolPharm(Map vol) {
  //   _volsPharm.add(vol);
  //   notifyListeners();
  // }

  // void addVolChem(Map vol) {
  //   _volsChem.add(vol);
  //   notifyListeners();
  // }
}
