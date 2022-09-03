import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../helpers/data_lists.dart';

import '../../../model/patient.dart';
import '../../../provider/patients/patients.dart';
import '../../../screens/patientscreen/widgets/patient_profile_screen/patient_profile_screen.dart';

class PatientListTile extends StatelessWidget {
  PatientListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final patient = Provider.of<Patient>(context);
    final patients = Provider.of<PatientsProv>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: (DateTime.parse(DateTime.now().toString())
                    .difference(
                      DateTime.parse(
                        patient.latests[0]['date'],
                      ),
                    )
                    .inDays <
                30)
            ? Colors.blue.shade300
            : Colors.deepOrange.withOpacity(.3),
        child: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    patient.name as String,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    patient.state != null ? patient.state as String : '',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  patient.volName as String,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(value: patient),
                    ChangeNotifierProvider.value(value: patients),
                  ],
                  child: PatientProfileScreen(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
