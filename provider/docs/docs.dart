import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/doc.dart';
import '../../provider/patients/patients.dart';

class Docs extends ChangeNotifier {
  Map<String, dynamic> _data = {};
  List<Doc> doctors = [];
  bool clicked = true;
  Future<void> refresh(
    BuildContext context,
  ) async {
    if (clicked) {
      print('loading reresh docsController');
      final database = FirebaseDatabase.instance;
      doctors = [];
      DataSnapshot? dataSnap;
      try {
        clicked = !clicked;

        dataSnap = await database.ref().child("doctors").get();
        clicked = !clicked;
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Container(
              height: 200,
              child: Center(child: Text('معلش غيرك اشطر')),
            ),
          ),
        );
      }

      if (dataSnap!.exists) {
        Map data = dataSnap.value as Map;
        _data = {...data};
        doctors = List.generate(
            _data.length,
            (i) => Doc()
              ..Id = _data.keys.elementAt(i)
              ..initData(_data.values.elementAt(i)));
      }
    }
    context.read<PatientsProv>().setCurrentDoctors(
        doctors.map((e) => {'name': e.name, 'idDoc': e.Id}).toList());
  }

  // void search(String searchFor, String? byname) {
  //   print('searching docs');
  //   searchedDoctors = [];
  //   doctors.forEach(
  //     (element) {
  //       {
  //         if ((byname == 'الاسم' || byname == null) && searchFor != '') {
  //           if (element.name.contains(searchFor)) {
  //             searchedDoctors.add(element);
  //           }
  //         }
  //       }
  //     },
  //   );
  //   notifyListeners();
  // }
}
