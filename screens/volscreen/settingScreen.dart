import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helpers/data_lists.dart';
import '../../model/user.dart';
import '../../model/volanteer.dart';
import '../../provider/bottom_navigationController.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final TextEditingController addClassiController = TextEditingController();
  final TextEditingController addTeamController = TextEditingController();
  final fkey = GlobalKey<FormState>();
  bool teaming = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0))),
                    backgroundColor: MaterialStateProperty.all(
                        teaming ? Colors.green : Colors.grey)),
                child: Text(
                  'تعديل التيمات',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: (teaming)
                    ? null
                    : () {
                        setState(() {
                          teaming = true;
                        });
                      },
              )),
              Expanded(
                  child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0))),
                    backgroundColor: MaterialStateProperty.all(
                        !teaming ? Colors.green : Colors.grey)),
                child: Text(
                  'تعديل الاختصاص',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: (!teaming)
                    ? null
                    : () {
                        setState(() {
                          teaming = false;
                        });
                      },
              )),
            ],
          ),
          if (!teaming)
            Form(
              key: fkey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
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
                      controller: addClassiController,
                      validator: (e) {
                        if (e == null || e == '') {
                          return 'أدخل اسم تخصص من فضلك';
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'أدخل تخصص جديد',
                        suffixIcon: IconButton(
                          onPressed: () async {
                            if (fkey.currentState!.validate()) {
                              final ref = FirebaseDatabase.instance
                                  .ref()
                                  .child('classification')
                                  .push();
                              await FirebaseDatabase.instance
                                  .ref(ref.path)
                                  .set(addClassiController.text);
                              addClassiController.clear();
                              context
                                  .read<BottomNavigationController>()
                                  .setIndex(context
                                      .watch<BottomNavigationController>()
                                      .index);
                            }
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.green[200],
                          ),
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
            ),
          if (!teaming)
            StreamBuilder<DatabaseEvent>(
                stream: FirebaseDatabase.instance
                    .ref()
                    .child('classification')
                    .onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  if (snapshot.data !=
                      null) if (snapshot.data!.snapshot.value != null) {
                    final data = (snapshot.data!.snapshot.value as Map);
                    return Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, i) => ListTile(
                          title: Text(data.values.elementAt(i)),
                          trailing: (data.values.elementAt(i) == 'غير محدد')
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                              title: Text(
                                                  'Are you sure for delete ${data.values.elementAt(i)}'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(ctx).pop();
                                                    },
                                                    child: Text('No!')),
                                                TextButton(
                                                    onPressed: () async {
                                                      final allUsers =
                                                          await FirebaseDatabase
                                                              .instance
                                                              .ref()
                                                              .child('users')
                                                              .get();
                                                      if (allUsers.value !=
                                                          null) {
                                                        final usersData =
                                                            allUsers.value
                                                                as Map;
                                                        print(usersData.values);
                                                        for (Map element
                                                            in usersData.values
                                                                .toList()) {
                                                          if (element[
                                                                  'classification'] ==
                                                              data.values
                                                                  .elementAt(
                                                                      i)) {
                                                            await FirebaseDatabase
                                                                .instance
                                                                .ref()
                                                                .child('users')
                                                                .child(usersData
                                                                    .keys
                                                                    .firstWhere((e) =>
                                                                        usersData[
                                                                            e] ==
                                                                        element))
                                                                .child(
                                                                    'classification')
                                                                .set(
                                                                    'غير محدد');
                                                          }
                                                        }
                                                      }
                                                      final allPatients =
                                                          await FirebaseDatabase
                                                              .instance
                                                              .ref()
                                                              .child('patients')
                                                              .get();
                                                      if (allPatients.value !=
                                                          null) {
                                                        final Map patientsData =
                                                            allPatients.value
                                                                as Map;
                                                        for (Map patient
                                                            in patientsData
                                                                .values) {
                                                          if (patient[
                                                                  'illnessType'] ==
                                                              data.values
                                                                  .elementAt(
                                                                      i)) {
                                                            await FirebaseDatabase
                                                                .instance
                                                                .ref()
                                                                .child(
                                                                    'patients')
                                                                .child(patient[
                                                                    'nationaId'])
                                                                .child(
                                                                    'illnessType')
                                                                .set(
                                                                    'غير محدد');
                                                          }
                                                        }
                                                      }
                                                      final allDoctors =
                                                          await FirebaseDatabase
                                                              .instance
                                                              .ref()
                                                              .child('doctors')
                                                              .get();
                                                      if (allDoctors.value !=
                                                          null) {
                                                        final Map doctorsData =
                                                            allDoctors.value
                                                                as Map;
                                                        for (Map doctor
                                                            in doctorsData
                                                                .values) {
                                                          if (doctor[
                                                                  'classification'] ==
                                                              data.values
                                                                  .elementAt(
                                                                      i)) {
                                                            await FirebaseDatabase
                                                                .instance
                                                                .ref()
                                                                .child(
                                                                    'doctors')
                                                                .child(doctorsData
                                                                    .keys
                                                                    .firstWhere((e) =>
                                                                        doctorsData[
                                                                            e] ==
                                                                        doctor))
                                                                .child(
                                                                    'classification')
                                                                .set(
                                                                    'غير محدد');
                                                          }
                                                        }
                                                      }
                                                      await FirebaseDatabase
                                                          .instance
                                                          .ref()
                                                          .child(
                                                              'classification')
                                                          .child(data.keys
                                                              .elementAt(i))
                                                          .set(null);
                                                      Navigator.of(ctx).pop();
                                                      if (curentUser
                                                              .classification ==
                                                          data.values
                                                              .elementAt(i))
                                                        curentUser
                                                                .classification =
                                                            'غير محدد';
                                                      context
                                                          .read<
                                                              BottomNavigationController>()
                                                          .setIndex(context
                                                              .watch<
                                                                  BottomNavigationController>()
                                                              .index);
                                                    },
                                                    child: Text('yes')),
                                              ],
                                            ));
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                        ),
                      ),
                    );
                  }
                  return Center(child: Text('لا يوجد تخصصات'));
                }),
          if (teaming)
            Form(
              key: fkey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
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
                      controller: addTeamController,
                      validator: (e) {
                        if (e == null || e == '') {
                          return 'أدخل اسم التيم من فضلك';
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'أدخل تيم جديد',
                        suffixIcon: IconButton(
                          onPressed: () async {
                            if (fkey.currentState!.validate()) {
                              final data = await FirebaseDatabase.instance
                                  .ref()
                                  .child('teams')
                                  .get();
                              List teamsData = [];
                              if (data.value != null)
                                teamsData = data.value as List;
                              await FirebaseDatabase.instance.ref().update({
                                'teams': List.generate(
                                    1 + teamsData.length,
                                    (index) => (index == 0)
                                        ? addTeamController.text
                                        : (teamsData)[index - 1]),
                              });

                              addTeamController.clear();
                              FocusScope.of(context).unfocus();
                              context
                                  .read<BottomNavigationController>()
                                  .setIndex(context
                                      .read<BottomNavigationController>()
                                      .index);
                            }
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.green,
                          ),
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
            ),
          if (teaming)
            StreamBuilder<DatabaseEvent>(
                stream: FirebaseDatabase.instance.ref().child('teams').onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  if (snapshot.data !=
                      null) if (snapshot.data!.snapshot.value != null) {
                    final data = (snapshot.data!.snapshot.value as List);
                    return Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, i) => ListTile(
                          title: Text(data[i]),
                          trailing: (data[i] == 'مطلق')
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                              title: Text(
                                                  'Are you sure for delete ${data[i]}'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(ctx).pop();
                                                    },
                                                    child: Text('No!')),
                                                TextButton(
                                                    onPressed: () async {
                                                      final allUsers =
                                                          await FirebaseDatabase
                                                              .instance
                                                              .ref()
                                                              .child('users')
                                                              .get();

                                                      if (allUsers.value !=
                                                          null) {
                                                        final usersData =
                                                            allUsers.value
                                                                as Map;

                                                        for (Map element
                                                            in (usersData)
                                                                .values
                                                                .toList()) {
                                                          if (element['team'] ==
                                                              data[i]) continue;
                                                          Volanteer volanteer =
                                                              Volanteer()
                                                                ..id = usersData
                                                                    .keys
                                                                    .firstWhere((e) =>
                                                                        usersData[
                                                                            e] ==
                                                                        element);

                                                          await FirebaseDatabase
                                                              .instance
                                                              .ref()
                                                              .child('users')
                                                              .child(volanteer
                                                                  .id as String)
                                                              .child('team')
                                                              .set('مطلق');
                                                        }
                                                      }
                                                      await FirebaseDatabase
                                                          .instance
                                                          .ref()
                                                          .child('teams')
                                                          .set(data
                                                              .where(
                                                                  (element) =>
                                                                      element !=
                                                                      data[i])
                                                              .toList());
                                                      if (curentUser.team ==
                                                          data[i])
                                                        curentUser.team =
                                                            'مطلق';
                                                      context
                                                          .read<
                                                              BottomNavigationController>()
                                                          .setIndex(context
                                                              .read<
                                                                  BottomNavigationController>()
                                                              .index);
                                                      Navigator.of(ctx).pop();
                                                    },
                                                    child: Text('yes')),
                                              ],
                                            ));
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                        ),
                      ),
                    );
                  }
                  return Center(child: Text('لا يوجد تيمات'));
                }),
        ],
      ),
    );
  }
}
