import 'package:flutter/material.dart';

class AddPatientTextField extends StatelessWidget {
  const AddPatientTextField({
    required this.label,
    required this.controller,
    required this.tKey,
    required this.save,
    required this.validate,
    required this.multiline,
    this.invisible,
    this.textInputAction,
    this.textInputType,
  });
  final String label;
  final TextEditingController controller;
  final Key tKey;
  final Function save;
  final Function validate;
  final bool multiline;
  final bool? invisible;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: const BorderSide(width: 1, color: Colors.greenAccent),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            // focusNode: FocusNode(canRequestFocus: false),
            maxLines: (multiline) ? 3 : 1,
            controller: controller,
            key: tKey,
            obscureText: (invisible != null) ? true : false,
            obscuringCharacter: '*',
            keyboardType: textInputType,
            textInputAction: textInputAction,
            decoration: InputDecoration(
              label: Text(label),
              border: InputBorder.none,
              errorBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
            ),
            validator: (v) => validate(v),
            onSaved: (v) => save(v),
          ),
        ),
      ),
    );
  }
}
