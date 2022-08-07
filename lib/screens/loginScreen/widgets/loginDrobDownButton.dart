import 'package:flutter/material.dart';

class LoginDrobDownButton extends StatelessWidget {
  const LoginDrobDownButton(
      {super.key,
      required this.value,
      required this.onChanged,
      required this.hint,
      required this.items});
  final String? value;
  final Function(String value) onChanged;
  final String hint;
  final List<String> items;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(width: 1, color: Colors.greenAccent),
        ),
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: DropdownButton<String>(
            onTap: () => FocusScope.of(context).unfocus(),
            isDense: true,
            elevation: 50,
            // focusColor: Colors.white,
            underline: Container(),
            hint: Text(hint),
            value: value,
            isExpanded: true,

            onChanged: (v) {
              onChanged(v as String);
            },
            items: List.generate(
              items.length,
              (index) => DropdownMenuItem<String>(
                value: items[index],
                child: Text(
                  items[index],
                ),
              ),
            ).toList(),
          ),
        ),
      ),
    );
  }
}
