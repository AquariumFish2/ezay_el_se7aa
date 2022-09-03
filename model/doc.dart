import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../provider/docs/checkBoxAddDocController.dart';
import '../provider/docs/validateAddDocController.dart';


class Doc {
  late Function ref;
  String? Id;
  String phone = "";
  String hint = "";
  String name = "";
  String email = "";
  String classification = '';
  bool agreed = false;
  List<Map> patients = [];
  bool value = true;
  String? val;

  void initData(Map data) {
    if (data['phone'] != null) phone = data['phone'];
    if (data['hint'] != null) hint = data['hint'];
    if (data['name'] != null) name = data['name'];
    if (data['agreed'] != null) agreed = data['agreed'];
    if (data['email'] != null) email = data['email'];
    if (data['classification'] != null) classification = data['classification'];
    if (data['petients'] != null)
      patients = (data['petients'] as Map).values.toList() as List<Map>;
    //  database.ref().child('doctors').child(id).get().then((v) {
    //   toAdd = v.value as Map<String, Object>;
    //   agreed = toAdd['agreed'] as bool;
    //   patients = [...toAdd['patients'] as List];
    //   val = toAdd['type'] as String;
    // });
  }

  void getTextFields(
      TextEditingController docNameController,
      TextEditingController docPhoneController,
      TextEditingController docEmailController,
      TextEditingController hintController,
      BuildContext context) {
    docNameController.text = name;
    docPhoneController.text = phone;
    docEmailController.text = email;
    hintController.text = hint;
    context.read<CheckBoxAddDocController>().value = agreed;
    if (classification != '')
      context.read<ValidateAddDocController>().classification = classification;
    if (docEmailController.text != '') {
      context.read<CheckBoxAddDocController>().value = true;
    }
    print(context.read<ValidateAddDocController>().classification);
  }

  void toggle() {
    agreed = !agreed;
  }

  setUserClassificationDropDownBottonValue(String val) {
    classification = val;
  }
}
