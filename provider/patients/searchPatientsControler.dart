import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../model/patient.dart';
import '../../provider/patients/patients.dart';

class SearchPatientsController extends ChangeNotifier {
  List<Patient> searchedPatients = [];
  searchItems(String value, BuildContext context) {
    searchedPatients = context.read<PatientsProv>().patients.where((element) {
      return (element.name as String).toLowerCase().contains(value);
    }).toList();
    print(searchedPatients);
    notifyListeners();
  }
}
