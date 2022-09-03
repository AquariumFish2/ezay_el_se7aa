import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../helpers/data_lists.dart';
import '../../../model/user.dart';
import '../../../provider/bottom_navigationController.dart';

import '../../../provider/docs/docs.dart';
import '../../../model/patient.dart';
import '../../../provider/patients/patients.dart';
import '../../../screens/patientscreen/add_patient_screen/widgets/illnesslist.dart';
import '../../../screens/patientscreen/add_patient_screen/widgets/state_dropdownbutton.dart';
import '../../../screens/widgets/custom_text_field.dart';
import '../../../screens/patientscreen/add_patient_screen/widgets/patient_screen_doctors_dropdownbutton.dart';
import 'package:sizer/sizer.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class AddPatientPage extends StatefulWidget {
  AddPatientPage({Key? key}) : super(key: key);

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  final fkey = GlobalKey<FormState>();

  final TextEditingController patientNameController = TextEditingController();

  final TextEditingController nationalIdController = TextEditingController();

  final TextEditingController patientPhoneController = TextEditingController();

  final TextEditingController patientAdressController = TextEditingController();

  final TextEditingController sourceController = TextEditingController();

  final TextEditingController illnessController = TextEditingController();

  final TextEditingController costController = TextEditingController();

  final TextEditingController costValueController = TextEditingController();

  final TextEditingController latestController = TextEditingController();

  final Key patientNameKey = const Key('patientName');

  final Key patientNumKey = const Key('patientNum');

  final Key nationalIdKey = const Key('NationalIdKey');

  final Key patientAdressKey = const Key('patientAdress');

  final Key sourceKey = const Key('sourceKey');

  final Key illnessKey = const Key('illnessKey');

  final Key latestKey = const Key('latestKey');

  List<File> _images = [];

  Future pickImage(bool galery) async {
    List? images;

    if (galery)
      images = await ImagePicker().pickMultiImage();
    else
      images = [await ImagePicker().pickImage(source: ImageSource.camera)];
    if (images != null)
      images.forEach((element) {
        if (element != null) _images.add(File((element as XFile).path));
      });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final patientsProvider = Provider.of<PatientsProv>(context, listen: false);
    final doctorsProvider = Provider.of<Docs>(context, listen: false);
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: doctorsProvider.refresh(
          context,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          return Builder(builder: (context) {
            final patientProvider = Provider.of<Patient>(context);
            void save(String id) async {
              if (fkey.currentState!.validate()) {
                // if (patientProvider.stateValidate == true) {
                patientProvider.date = DateTime.now().toIso8601String();
                final database = FirebaseDatabase.instance.ref();
                fkey.currentState!.save();
                List imagesUrl = [];
                _images.forEach((element) async {
                  final fileId = DateTime.now().toString();
                  imagesUrl.add('${id}_$fileId');
                  await FirebaseStorage.instance
                      .ref('patients/${id}_$fileId')
                      .putFile(element);
                });
                final teamName = await FirebaseDatabase.instance
                    .ref()
                    .child('users')
                    .child(curentUser.id as String)
                    .child('team')
                    .get();
                final ref = database
                    .child('patients')
                    .child(patientProvider.nationalId as String)
                    .update({
                  'images': imagesUrl,
                  'team': teamName.value,
                  'volanteerId': curentUser.id,
                  'volanteerName': patientProvider.volName,
                  'patientName': patientProvider.name,
                  'nationaId': patientProvider.nationalId,
                  'docId': patientProvider.docId,
                  'docName': patientProvider.doctor,
                  'illnessType': patientProvider.illnessType,
                  'illness': patientProvider.illness,
                  'availableForGuests': false,
                  'costs': Map.fromIterable(
                    patientProvider.costs,
                    key: (e) => e['id'],
                    value: (e) =>
                        {'التكليف': e['التكليف'], 'القيمة': e['القيمة']},
                  ),
                  'adress': patientProvider.address,
                  'phone': patientProvider.phone,
                  'source': patientProvider.source,
                  'latests': Map.fromIterable(
                    patientProvider.latests,
                    key: (e) {
                      return e['id'];
                    },
                    value: (e) {
                      if (e['date'] == null)
                        e['date'] = DateTime.now().toIso8601String();
                      return {
                        'date': e['date'],
                        'title': e['title'],
                      };
                    },
                  ),
                  'state': patientProvider.state,
                  'date': patientProvider.date,
                });
                // patientsProvider.clear();
                context
                    .read<BottomNavigationController>()
                    .setIndex(context.read<BottomNavigationController>().index);
                Navigator.pop(context);
              }
              // } else
              //   patientProvider.stateNotvalidated();
            }

            return Form(
              key: fkey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AddPatientTextField(
                      label: 'الاسم',
                      controller: patientNameController,
                      tKey: patientNameKey,
                      save: (v) {
                        patientProvider.name = v;
                      },
                      validate: (String v) {
                        if (v.length < 4) return 'ادخل اسم صحيح';
                      },
                      multiline: false,
                    ),
                    AddPatientTextField(
                      label: 'الرقم القومي',
                      controller: nationalIdController,
                      textInputAction: TextInputAction.next,
                      tKey: nationalIdKey,
                      save: (v) {
                        patientProvider.nationalId = v;
                      },
                      validate: (String v) {
                        if (v.length != 14) return 'ادخل رقم قومي صحيح';
                      },
                      multiline: false,
                    ),
                    AddPatientTextField(
                      label: 'رقم التلفون',
                      controller: patientPhoneController,
                      tKey: patientNumKey,
                      save: (v) {
                        patientProvider.phone = v;
                      },
                      validate: (String v) {
                        if (v.length != 10 && v.length != 11)
                          return 'ادخل رقم صحيح';
                      },
                      multiline: false,
                    ),
                    StateDropDownButton(
                      label: 'اختر المركز',
                      items: states,
                    ),
                    AddPatientTextField(
                      label: 'العنوان',
                      controller: patientAdressController,
                      tKey: patientAdressKey,
                      multiline: false,
                      save: (v) {
                        patientProvider.address = v;
                      },
                      validate: (String v) {
                        if (v.length < 4) return 'ادخل عنوان مناسب';
                      },
                    ),
                    // if (patientProvider.stateValidate == false)
                    //   Text("أختار مركز من فضلك"),
                    AddPatientTextField(
                      label: 'اسم السورس',
                      controller: sourceController,
                      tKey: sourceKey,
                      multiline: false,
                      save: (v) => patientProvider.source = v,
                      validate: (v) {
                        if (v.length < 4) return 'ادخل اسم صحيح';
                      },
                    ),
                    FutureBuilder<DataSnapshot>(
                        future: FirebaseDatabase.instance
                            .ref()
                            .child('classification')
                            .get(),
                        builder: (context, snap) {
                          if (snap.connectionState == ConnectionState.waiting)
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          if (snap.data != null) if (snap.data!.value != null) {
                            final Map classificationsData =
                                snap.data!.value as Map;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    width: 1,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 6),
                                  child: DropdownButton(
                                    onTap: () =>
                                        FocusScope.of(context).unfocus(),
                                    underline: Container(),
                                    isExpanded: true,
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    hint: Text(
                                      'تخصص المرض',
                                    ),
                                    value: patientProvider.illnessType,
                                    items: classificationsData.values
                                        .map(
                                          (e) => DropdownMenuItem(
                                            child: Text(e),
                                            value: e,
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) {
                                      patientProvider
                                          .setillnessType(v as String);
                                    },
                                  ),
                                ),
                              ),
                            );
                          }
                          return Container();
                        }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: PatientDropDown(
                              text: 'اختر الطبيب المتابع',
                            ),
                          )
                        ],
                      ),
                    ),
                    AddPatientTextField(
                      label: 'المرض المصاحب للمريض',
                      controller: illnessController,
                      tKey: illnessKey,
                      multiline: false,
                      save: (v) => patientProvider.illness = v,
                      validate: (String v) {
                        if (v.length == 0) return 'ادخل المرض من فضلك';
                      },
                    ),
                    IllnessList(
                        costController: costController,
                        costValueController: costValueController),
                    AddPatientTextField(
                      label: 'اخر ما وصلناله',
                      controller: latestController,
                      tKey: latestKey,
                      validate: (v) {},
                      save: (v) => patientProvider.setLatest(v),
                      multiline: true,
                    ),
                    (_images.length == 0)
                        ? GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Card(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width: 35.w,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Expanded(
                                                          child: IconButton(
                                                            onPressed:
                                                                () async {
                                                              await pickImage(
                                                                  true);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            icon: Icon(
                                                                Icons.image),
                                                          ),
                                                        ),
                                                        Expanded(
                                                            child: Text(
                                                                "pick an image"))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Card(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width: 35.w,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Expanded(
                                                          child: IconButton(
                                                            onPressed:
                                                                () async {
                                                              await pickImage(
                                                                  false);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            icon: Icon(
                                                                Icons.camera),
                                                          ),
                                                        ),
                                                        Expanded(
                                                            child: Text(
                                                                "Take a photo")),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                            },
                            child: Container(
                              color: Colors.grey[200],
                              margin: EdgeInsets.only(top: 20),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40.w, vertical: 10.h),
                              child: Icon(
                                Icons.add_a_photo,
                                color: Colors.green,
                                size: 36,
                              ),
                            ),
                          )
                        : GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _images.length,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            itemBuilder: (BuildContext context, int index) =>
                                Container(
                              child: Image.file(
                                _images[index],
                              ),
                            ),
                          ),

                    ElevatedButton(
                        onPressed: () => save(curentUser.id as String),
                        child: const Text('save')),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
