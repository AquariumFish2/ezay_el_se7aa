import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../helpers/data_lists.dart';
import '../../model/patient.dart';

class PatientsProv extends ChangeNotifier {
  List<Patient> _patients = [];
  List<Map> _currentDoctors = [];
  List<Map> get currentDoctors => _currentDoctors;
  bool clicked = true;
  List<Patient> get patients {
    return _patients;
  }

  void clear() {
    _patients = [];
  }

  void addPatient(Map newPatient) {
    _patients.add(Patient()
      ..team = newPatient['team']
      ..images = (newPatient['images'] != null)
          ? [...newPatient['images'] as List]
          : []
      ..volId = newPatient['volanteerId']
      ..volName = newPatient['volanteerName']
      ..name = newPatient['patientName']
      ..nationalId = newPatient['nationaId']
      ..docId = newPatient['docId']
      ..doctor = newPatient['docName']
      ..illnessType = newPatient['illnessType']
      ..illness = newPatient['illness']
      ..costs = [
        if ((newPatient['costs']) != null)
          ...(newPatient['costs'] as Map).keys.map((e) => {
                'id': e,
                'التكليف': newPatient['costs'][e]['التكليف'],
                'القيمة': newPatient['costs'][e]['القيمة'],
              })
      ]
      ..address = newPatient['adress']
      ..phone = newPatient['phone']
      ..source = newPatient['source']
      ..availableForGuests = newPatient['availableForGuests']
      ..latests = [
        if (newPatient['latests'] != null)
          ...(newPatient['latests'] as Map).keys.map((e) => {
                'id': e,
                'date': newPatient['latests'][e]['date'],
                'title': newPatient['latests'][e]['title'],
              })
      ]
      ..state = newPatient['state']
      ..date = newPatient['date']);
  }

  Future<void> refresh(
    BuildContext context,
  ) async {
    if (clicked) {
      _patients = [];
      clicked = false;
      // final dataTeamColorRefresh =
      //     await FirebaseDatabase.instance.ref().child('teams').get();

      final database = FirebaseDatabase.instance;
      var ref;
      try {
        ref = await database.ref().child("patients").get();
      } catch (error) {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Container(
              height: 200,
              child: Center(child: Text('حدث خطأ كلم مسؤول الملف')),
            ),
          ),
        );
      }
      if (ref.exists) {
        (ref.value as Map).values.forEach((element) {
          addPatient(element);
        });
      }
      clicked = true;
      sortLatest();
    }
  }

  sortLatest() {
    for (int i = 0; i < _patients.length; i++) {
      for (int y = i + 1; y < _patients.length; y++) {
        if (DateTime.parse(_patients[y].date as String)
            .isAfter(DateTime.parse(_patients[i].date as String))) {
          Patient temp = _patients[i];
          _patients[i] = _patients[y];
          patients[y] = temp;
        }
      }
    }

    // patients.forEach((element) {
    //   for (int i = 0; i < element.latests.length; i++) {
    //     for (int y = i + 1; i < element.latests.length; y++) {
    //       if (DateTime.parse(element.latests[y]['date'] as String)
    //           .isAfter(DateTime.parse(element.latests[i]['date'] as String))) {
    //         Map temp = element.latests[i];
    //         element.latests[i] = element.latests[y];
    //         element.latests[y] = temp;
    //       }
    //     }
    //   }
    // });
  }

  void setCurrentDoctors(List<Map> doctors) {
    _currentDoctors = doctors;
    notifyListeners();
  }
}
