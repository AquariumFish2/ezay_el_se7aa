import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../helpers/data_lists.dart';
import '../../../../model/patient.dart';
import '../../../../model/screens_spiprit_handle.dart';
import '../../../../provider/bottom_navigationController.dart';
import '../../../../provider/patients/patients.dart';
import '../../../../model/volanteer.dart';
import '../../../../provider/volanteers.dart';
import '../../../../screens/patientscreen/add_patient_screen/widgets/patient_screen_doctors_dropdownbutton.dart';
import '../../../../screens/patientscreen/add_patient_screen/widgets/state_dropdownbutton.dart';
import '../../../../screens/patientscreen/widgets/patient_profile_screen/widgets/dropdown_dialog_prof_patient_screen.dart';
import '../../../../screens/patientscreen/widgets/patient_profile_screen/widgets/images_list.dart';
import '../../../../screens/patientscreen/widgets/patient_profile_screen/widgets/need.dart';
import '../../../../screens/patientscreen/widgets/patient_profile_screen/widgets/patient_profile_listtile.dart';
import '../../../../screens/patientscreen/widgets/patient_profile_screen/widgets/text_field_dialog_prof_patient_screen.dart';

//need to clean
class PatientProfileScreen extends StatelessWidget {
  PatientProfileScreen({
    Key? key,
  }) : super(key: key);
  TextEditingController dialogLatestController = TextEditingController();
  TextEditingController dialogCostController = TextEditingController();
  TextEditingController dialogCostValueController = TextEditingController();
  TextEditingController dialogNameController = TextEditingController();
  TextEditingController dialogNationIdController = TextEditingController();
  TextEditingController dialogAdressController = TextEditingController();
  TextEditingController dialogPhoneController = TextEditingController();
  TextEditingController dialogSourceController = TextEditingController();
  TextEditingController dialogIllnessController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final patient = Provider.of<Patient>(context);
    final patients = Provider.of<PatientsProv>(context);
    //need edit in canaccess
    bool canAccess = true;
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text(
          'فورم الحالة',
          style: TextStyle(
            color: Colors.green,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: (!canAccess)
            ? null
            : PopupMenuButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.green,
                ),
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              'ازل الحالة بالكامل ؟',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        onTap: () {
                          FirebaseDatabase.instance
                              .ref()
                              .child('patients')
                              .child(patient.nationalId as String)
                              .set(null);
                          patient.images.forEach((element) {
                            FirebaseStorage.instance
                                .ref()
                                .child('patients')
                                .child(element)
                                .delete();
                          });
                          Navigator.pop(context);
                          context.read<BottomNavigationController>().setIndex(
                              context
                                  .watch<BottomNavigationController>()
                                  .index);
                        },
                      ),
                    ]),
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_forward_rounded,
              color: Colors.green,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          PatientProfieListTile(
            access: canAccess,
            title: 'الاسم :',
            trailing: patient.name,
            editFunction: (!canAccess)
                ? null
                : () {
                    showDialog(
                      context: context,
                      builder: (ctx) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider.value(value: patient),
                          ChangeNotifierProvider.value(
                              value:
                                  context.watch<BottomNavigationController>())
                        ],
                        child: TextFieldDialog(
                          typeChanges: 'تغيير الاسم',
                          currentValue: patient.name as String,
                          controller: dialogNameController,
                          keyOfDataBase: 'patientName',
                          setValue: (value) {
                            patient.setName(value);
                          },
                        ),
                      ),
                    );
                  },
          ),
          PatientProfieListTile(
            title: 'اسم المتابع',
            trailing: patient.volName,
            //edit access by role
            ////////////////////////////////////////
            access: false,
            editFunction: () {
              showDialog(
                  context: context,
                  builder: (ctx) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider.value(
                            value: patient,
                          ),
                        ],
                        child: Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    'تغيير اسم المتطوع',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FutureBuilder<DataSnapshot>(
                                      future: FirebaseDatabase.instance
                                          .ref()
                                          .child('users')
                                          .get(),
                                      builder: (context, snapUsers) {
                                        if (snapUsers.connectionState ==
                                            ConnectionState.waiting)
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        Map allUsers = {};
                                        if (snapUsers.data !=
                                            null) if (snapUsers
                                                .data!.value !=
                                            null)
                                          allUsers =
                                              snapUsers.data!.value as Map;
                                        final patient =
                                            Provider.of<Patient>(context);
                                        if (allUsers.length == 0)
                                          return Text('لا يوجد متطوعين');

                                        return Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            side: BorderSide(
                                              width: 1,
                                              color: Colors.greenAccent,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: DropdownButton(
                                              borderRadius:
                                                  BorderRadius.circular(15),
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
                                              value: patient.volId,
                                              items: allUsers.values
                                                  .map((e) => DropdownMenuItem(
                                                      child:
                                                          Text(e['userName']),
                                                      value: allUsers.keys
                                                          .firstWhere((el) =>
                                                              allUsers[el] ==
                                                              e)))
                                                  .toList(),
                                              onChanged: (v) {
                                                patient.setVolName(
                                                    v as String,
                                                    allUsers[v]['team'],
                                                    allUsers[v]['userName']);
                                              },
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Divider(
                                    color: Colors.grey,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Builder(
                                    builder: (context) {
                                      final patient = Provider.of<Patient>(
                                          context,
                                          listen: false);
                                      return TextButton(
                                        onPressed: () async {
                                          await FirebaseDatabase.instance
                                              .ref()
                                              .child('patients')
                                              .child(
                                                  patient.nationalId as String)
                                              .update({
                                            'volanteerName': patient.volName,
                                            'volanteerId': patient.volId,
                                            'team': patient.team,
                                          });
                                          Navigator.of(context).pop();
                                          context
                                              .read<
                                                  BottomNavigationController>()
                                              .setIndex(context
                                                  .watch<
                                                      BottomNavigationController>()
                                                  .index);
                                        },
                                        child: Text('save'),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ));
            },
          ),
          PatientProfieListTile(
            access: canAccess,
            title: 'الرقم القومي :',
            trailing: patient.nationalId,
            editFunction: () {
              showDialog(
                context: context,
                builder: (ctx) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(value: patient),
                  ],
                  child: TextFieldDialog(
                    typeChanges: 'تغيير الرقم القومي',
                    currentValue: patient.nationalId as String,
                    controller: dialogNationIdController,
                    keyOfDataBase: 'nationId',
                  ),
                ),
              );
            },
          ),
          PatientProfieListTile(
            access: canAccess,
            title: 'المركز :',
            trailing: patient.state,
            editFunction: () {
              showDialog(
                  context: context,
                  builder: (ctx) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider.value(
                            value: patient,
                          ),
                        ],
                        child: DropDownDialog(
                          typeChanges: 'تغيير المركز',
                          dropDownButton: StateDropDownButton(
                            label: 'اختر المركز',
                            items: states,
                          ),
                          changes: 'state',
                        ),
                      ));
            },
          ),
          PatientProfieListTile(
            access: canAccess,
            title: 'العنوان :',
            trailing: patient.address,
            editFunction: () {
              showDialog(
                context: context,
                builder: (ctx) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(value: patient),
                  ],
                  child: TextFieldDialog(
                    typeChanges: 'تغيير العنوان',
                    currentValue: patient.address as String,
                    controller: dialogAdressController,
                    keyOfDataBase: 'adress',
                    setValue: (p0) => patient.setAddress(p0),
                  ),
                ),
              );
            },
          ),
          PatientProfieListTile(
            access: canAccess,
            title: 'رقم المحمول :',
            trailing: patient.phone,
            editFunction: () {
              showDialog(
                context: context,
                builder: (ctx) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(value: patient),
                  ],
                  child: TextFieldDialog(
                    typeChanges: 'تغيير المحمول',
                    currentValue: patient.phone as String,
                    controller: dialogPhoneController,
                    keyOfDataBase: 'phone',
                    setValue: (p0) => patient.setPhone(p0),
                  ),
                ),
              );
            },
          ),
          PatientProfieListTile(
            access: canAccess,
            title: 'السورس :',
            trailing: patient.source,
            editFunction: () {
              showDialog(
                context: context,
                builder: (ctx) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(value: patient),
                  ],
                  child: TextFieldDialog(
                    typeChanges: 'تغيير المصدر',
                    currentValue: patient.source as String,
                    controller: dialogSourceController,
                    keyOfDataBase: 'source',
                    setValue: (p0) => patient.setSource(p0),
                  ),
                ),
              );
            },
          ),
          PatientProfieListTile(
            access: canAccess,
            title: 'نوع المرض :',
            trailing: patient.illnessType,
            editFunction: () {
              showDialog(
                  context: context,
                  builder: (ctx) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider.value(value: patient),
                        ],
                        child: FutureBuilder<DataSnapshot>(
                            future: FirebaseDatabase.instance
                                .ref()
                                .child('classification')
                                .get(),
                            builder: (context, snap) {
                              if (snap.connectionState ==
                                  ConnectionState.waiting)
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              if (snap.data != null) if (snap.data!.value !=
                                  null) {
                                final Map classificationData =
                                    snap.data!.value as Map;
                                return DropDownDialog(
                                  typeChanges: 'تغيير نوع المرض',
                                  dropDownButton: Builder(builder: (context) {
                                    final patient =
                                        Provider.of<Patient>(context);
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: BorderSide(
                                          width: 1,
                                          color: Colors.greenAccent,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: DropdownButton(
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                                          value: patient.illnessType,
                                          items: classificationData.values
                                              .map((e) => DropdownMenuItem(
                                                  child: Text(e), value: e))
                                              .toList(),
                                          onChanged: (v) {
                                            patient.setillnessType(v as String);
                                          },
                                        ),
                                      ),
                                    );
                                  }),
                                  changes: 'illnessType',
                                );
                              }
                              return Text('حدث خطأ أخبر مسؤول الملف');
                            }),
                      ));
            },
          ),
          PatientProfieListTile(
            access: canAccess,
            title: 'اسم الطبيب المتابع :',
            trailing: patient.doctor,
            editFunction: () {
              showDialog(
                  context: context,
                  builder: (ctx) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider.value(
                            value: patient,
                          ),
                          ChangeNotifierProvider.value(value: patients),
                        ],
                        child: DropDownDialog(
                          typeChanges: 'تغيير الطبيب',
                          dropDownButton: PatientDropDown(
                            text: 'اختر الطبيب المتابع',
                          ),
                          changes: 'docName',
                        ),
                      ));
            },
          ),
          PatientProfieListTile(
            access: canAccess,
            title: 'المرض :',
            trailing: patient.illness,
            editFunction: () {
              showDialog(
                context: context,
                builder: (ctx) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(value: patient),
                  ],
                  child: TextFieldDialog(
                    typeChanges: 'تغيير المرض',
                    currentValue: patient.illness as String,
                    controller: dialogIllnessController,
                    keyOfDataBase: 'illness',
                    setValue: (p0) => patient.setIllness(p0),
                  ),
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'الاحتياجات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              // if (patient.volId == account.id ||
              //     account.role == 'مسؤول الملف' ||
              //     account.role == 'مسؤول المتطوعين' ||
              //     (account.role == 'مسؤول تيم' && account.team == patient.team))
              IconButton(
                  color: Colors.white,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (ctx) => Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 16),
                                    child: Text(
                                      'الاحتياج :-',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  //Text(patient.name as String),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1,
                                          color: Colors.greenAccent,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: TextField(
                                          controller: dialogCostController,
                                          decoration: InputDecoration(
                                            hintText: 'الاسم',
                                            border: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            focusedErrorBorder:
                                                InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1,
                                          color: Colors.greenAccent,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: TextField(
                                          controller: dialogCostValueController,
                                          decoration: InputDecoration(
                                            hintText: 'التكلفة',
                                            border: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            focusedErrorBorder:
                                                InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: TextButton(
                                        onPressed: () async {
                                          await FirebaseDatabase.instance
                                              .ref()
                                              .child('patients')
                                              .child(
                                                  patient.nationalId as String)
                                              .child('costs')
                                              .child(
                                                  '${(DateTime.now().second)}:${(DateTime.now().millisecond)}')
                                              .set({
                                            'التكليف':
                                                dialogCostController.text,
                                            'القيمة':
                                                dialogCostValueController.text,
                                          });
                                          Navigator.of(ctx).pop();
                                          context
                                              .read<
                                                  BottomNavigationController>()
                                              .setIndex(context
                                                  .watch<
                                                      BottomNavigationController>()
                                                  .index);
                                          patient.addCost(
                                            {
                                              'التكليف':
                                                  dialogCostController.text,
                                              'القيمة':
                                                  dialogCostValueController.text
                                            },
                                          );
                                          dialogCostController.clear();
                                          dialogCostValueController.clear();
                                          // dialogCostController.clear();
                                        },
                                        child: Text('save')),
                                  ),
                                ],
                              ),
                            ));
                  },
                  icon: Icon(Icons.add)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  width: 1,
                  color: Colors.blue.shade300,
                ),
              ),
              child: Builder(builder: (context) {
                num total = 0;
                patient.costs.forEach((need) {
                  total += int.parse(need['القيمة']);
                });
                return Column(
                  children: [
                    ...List.generate(
                      patient.costs.length,
                      (index) => Need(
                        needName: patient.costs[index]['التكليف'],
                        needCost: patient.costs[index]['القيمة'],
                      ),
                    ),
                    Need(needName: 'التوتال', needCost: total.toString())
                  ],
                );
              }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'اخر ما وصلناله',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              // if (patient.volId == account.id ||
              //     account.role == 'مسؤول الملف' ||
              //     account.role == 'مسؤول المتطوعين' ||
              //     (account.role == 'مسؤول تيم' && account.team == patient.team))
              IconButton(
                  color: Colors.white,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (ctx) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 16),
                                    child: Text(
                                      'أدخل أخر ما وصلته مع الحالة :-',
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 16),
                                    ),
                                  ),
                                  Text(patient.name as String),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1,
                                          color: Colors.greenAccent,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: TextField(
                                        controller: dialogLatestController,
                                        decoration: InputDecoration(
                                          hintText: 'اخر ما وصلناله',
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
                                  TextButton(
                                      onPressed: () async {
                                        await FirebaseDatabase.instance
                                            .ref()
                                            .child('patients')
                                            .child(patient.nationalId as String)
                                            .child('latests')
                                            .child(
                                                '${(DateTime.now().second)}:${(DateTime.now().millisecond)}')
                                            .set({
                                          'title': dialogLatestController.text,
                                          'date': DateTime.now().toString(),
                                        });
                                        Navigator.of(ctx).pop();
                                        Navigator.of(context).pop();
                                        context
                                            .read<BottomNavigationController>()
                                            .setIndex(context
                                                .watch<
                                                    BottomNavigationController>()
                                                .index);
                                      },
                                      child: Text('save')),
                                ],
                              ),
                            ));
                  },
                  icon: Icon(Icons.add))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  width: 1,
                  color: Colors.blue.shade300,
                ),
              ),
              child: Column(
                children: List.generate(
                  patient.latests.length,
                  (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      Expanded(
                          child: Text(
                        patient.latests[index]['title'],
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
                      Text(
                        DateFormat('M/d/y').format(
                            DateTime.parse(patient.latests[index]['date'])),
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ),
          ImagesList(),
        ],
      ),
    );
  }
}
