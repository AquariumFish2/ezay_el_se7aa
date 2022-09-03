import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../model/patient.dart';
import '../../../../provider/patients/patients.dart';

// ignore: must_be_immutable
class PatientDropDown extends StatelessWidget {
  PatientDropDown({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;
  String? value;

  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<Patient>(context);
    final patientsProvider = Provider.of<PatientsProv>(context);
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(width: 1, color: Colors.greenAccent)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
        child: DropdownButton(
          onTap: () => FocusScope.of(context).unfocus(),
          isExpanded: true,
          hint: Text(
            text,
          ),
          value: patientProvider.docId,
          underline: Container(),
          style: TextStyle(
            color: Colors.green,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          onChanged: (v) => patientProvider.setDoctor(
              v as String, patientsProvider.currentDoctors),
          items: patientsProvider.currentDoctors
              .where((doctor) => (patientProvider.illnessType == 'غير محدد' ||
                      patientProvider.illnessType == null)
                  ? true
                  : doctor['classification'] == patientProvider.illnessType)
              .map(
                (e) => DropdownMenuItem(
                  child: Text(e['name']),
                  value: e['idDoc'],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
