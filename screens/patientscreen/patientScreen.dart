import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/docs/docs.dart';
import '../../model/patient.dart';
import '../../provider/patients/patients.dart';
import '../../provider/patients/searchPatientsControler.dart';
import '../../screens/patientscreen/widgets/patient_list.dart';
import '../../screens/patientscreen/widgets/patient_list_tile.dart';
import '../widgets/app_bar_button.dart';
import 'add_patient_screen/add_patient_screen.dart';
import 'package:sizer/sizer.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({Key? key}) : super(key: key);

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  bool search = false;
  List<Patient> searchedPatient = [];
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الحالات'),
        actions: [
          if (search)
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  search = false;
                });
              },
            ),
          if (!search)
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  search = true;
                });
              },
            ),
          if (!search)
            AppBarButton(onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                      create: (context) => Patient(), child: AddPatientPage()),
                ),
              );
            }),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.fill,
              width: 100.w,
            ),
          ),
          if (search)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'ادخل اسم الحالة او الرقم القومي او رقم الهاتف',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 15),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green.shade50.withOpacity(.2),
                        borderRadius: BorderRadius.circular(15),
                        border:
                            Border.all(width: 1, color: Colors.green.shade400)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 10),
                      child: TextFormField(
                        onChanged: (value) {
                          context
                              .read<SearchPatientsController>()
                              .searchItems(value, context);
                        },
                        decoration: InputDecoration(
                          hintText: 'كلمة البحث',
                          suffixIcon: Icon(
                            Icons.search,
                            color: Colors.green[200],
                          ),
                          hintStyle: TextStyle(color: Colors.green[200]),
                          // label: Text(label),

                          border: InputBorder.none,
                          errorBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                ListView(
                  shrinkWrap: true,
                  children: context
                      .watch<SearchPatientsController>()
                      .searchedPatients
                      .map((e) => ChangeNotifierProvider.value(
                            value: e,
                            child: PatientListTile(),
                          ))
                      .toList(),
                ),
              ],
            ),
          if (!search) PatientList(),
        ],
      ),
    );
  }
}
