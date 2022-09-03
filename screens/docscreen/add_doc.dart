import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helpers/data_lists.dart';
import '../../model/doc.dart';
import '../../provider/bottom_navigationController.dart';
import '../../provider/docs/checkBoxAddDocController.dart';
import '../../provider/docs/switchAddDocController.dart';
import '../../provider/docs/validateAddDocController.dart';
import '../../screens/widgets/custom_text_field.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class AddDoctor extends StatelessWidget {
  AddDoctor(this.doc, {Key? ky}) : super(key: ky);
  bool once = true;
  final Doc doc;
  final GlobalKey<FormState> keys = GlobalKey<FormState>();
  final TextEditingController docNameController = TextEditingController();
  final TextEditingController docPhoneController = TextEditingController();
  final TextEditingController docEmailController = TextEditingController();
  final TextEditingController hintController = TextEditingController();
  final Key docNameKey = const Key('docName');
  final Key docPhoneKey = const Key('docPhone');
  final Key docEmailKey = const Key('docEmail');
  final Key hintKey = const Key('doctorHint');
  void fitchLastData(Doc doc, BuildContext context) {
    doc.getTextFields(docNameController, docPhoneController, docEmailController,
        hintController, context);
  }

  final database = FirebaseDatabase.instance;
  void save(Doc doc, BuildContext context) {
    bool validate = keys.currentState!.validate();

    if (validate && context.read<ValidateAddDocController>().tryToValidate()) {
      // prove.type = prove.val as String;

      keys.currentState!.save();
      DatabaseReference ref;

      if (doc.Id == null) {
        ref = database.ref().child('doctors').push();
      } else
        ref = database.ref().child('doctors').child(doc.Id as String);
      try {
        database.ref(ref.path).set({
          "phone": doc.phone,
          "agreed": context.read<CheckBoxAddDocController>().value,
          "hint": doc.hint,
          "name": doc.name,
          "classification":
              context.read<ValidateAddDocController>().classification,
          "email": (context.read<CheckBoxAddDocController>().value)
              ? doc.email
              : null,
        });
        Navigator.of(context).pop();
        context
            .read<BottomNavigationController>()
            .setIndex(context.read<BottomNavigationController>().index);
      } catch (error) {
        print(error);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.toString(),
            ),
          ),
        );
      }
      // database.ref()
      // .set(toAdd);
      //prove.ref();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build add doctor');

    //final staticProve = Provider.of<Doc>(context, listen: false);

    // staticProve.getTextFields(docNameController, docPhoneController,
    //     docEmailController, hintController);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SwitchAddDocController()),
        ChangeNotifierProvider(create: (context) => CheckBoxAddDocController()),
        ChangeNotifierProvider(create: (context) => ValidateAddDocController()),
      ],
      child: Builder(builder: (context) {
        if (once) {
          fitchLastData(doc, context);
          once = false;
        }
        return Scaffold(
          appBar: AppBar(),
          body: Form(
            key: keys,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AddPatientTextField(
                      label: 'اسم الدكتور',
                      controller: docNameController,
                      tKey: docNameKey,
                      save: (v) => {doc.name = v as String},
                      validate: (v) {
                        if (v!.length < 4) return 'ادخل اسم صحيح';
                      },
                      textInputAction: TextInputAction.next,
                      multiline: false),
                  Row(
                    children: [
                      SizedBox(
                          width: 80.w,
                          child: AddPatientTextField(
                              textInputAction: TextInputAction.next,
                              textInputType: TextInputType.phone,
                              label: 'رقم التليفون',
                              controller: docPhoneController,
                              tKey: docPhoneKey,
                              save: (v) => doc.phone = v as String,
                              validate: (v) {
                                if (v!.length != 10 && v.length != 11) {
                                  return ' ادخل رقم هاتف صحيح';
                                }
                              },
                              multiline: false)),
                      Switch(
                        value: context.watch<SwitchAddDocController>().value,
                        onChanged: (v) {
                          context.read<SwitchAddDocController>().togleValue();
                        },
                      ),
                    ],
                  ),
                  (!context.watch<SwitchAddDocController>().value)
                      ? Container()
                      : AddPatientTextField(
                          label: 'طريقة التواصل',
                          controller: docEmailController,
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.emailAddress,
                          tKey: docEmailKey,
                          save: (v) => doc.email = v as String,
                          validate: (v) {
                            if (!v!.contains('@') || !v.contains('.com')) {
                              return 'ادخل بريد الكتروني صحيح';
                            }
                          },
                          multiline: false),
                  AddPatientTextField(
                      label: 'ملاحظة',
                      controller: hintController,
                      tKey: hintKey,
                      save: (v) => doc.hint = v as String,
                      validate: (v) {},
                      multiline: true),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: FutureBuilder<DataSnapshot>(
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
                            final classifications = snap.data!.value as Map;

                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: const BorderSide(
                                                  width: 1,
                                                  color: Colors.greenAccent),
                                            ),
                                            elevation: 0,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: DropdownButton(
                                                onTap: () =>
                                                    FocusScope.of(context)
                                                        .unfocus(),
                                                isExpanded: true,
                                                elevation: 50,
                                                // focusColor: Colors.white,
                                                underline: Container(),
                                                value: context
                                                    .read<
                                                        ValidateAddDocController>()
                                                    .classification,
                                                hint: const Text('اختر التخصص'),
                                                onChanged: (v) => context
                                                    .read<
                                                        ValidateAddDocController>()
                                                    .setClassification(
                                                        v as String),
                                                items: List.generate(
                                                  classifications.length,
                                                  (index) => DropdownMenuItem(
                                                    child: Text(
                                                      classifications.values
                                                          .elementAt(index),
                                                    ),
                                                    value: classifications
                                                        .values
                                                        .elementAt(index),
                                                  ),
                                                ).toList(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (context
                                    .watch<ValidateAddDocController>()
                                    .validate)
                                  Center(
                                    child: Text(
                                      'أدخل التخصص من فضلك',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                              ],
                            );
                          }
                          return Container();
                        }),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 7),
                    child: GestureDetector(
                      child: Row(
                        children: [
                          const Text('موافق يشتغل معانا؟'),
                          const Spacer(),
                          (!context.watch<CheckBoxAddDocController>().value)
                              ? const Icon(
                                  Icons.check_box_outlined,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.check_box,
                                  color: Colors.green,
                                ),
                        ],
                      ),
                      onTap: () {
                        context.read<CheckBoxAddDocController>().toggleValue();
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      save(doc, context);
                    },
                    child: const Text('save'),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(
                        Size.fromWidth(80.w),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
