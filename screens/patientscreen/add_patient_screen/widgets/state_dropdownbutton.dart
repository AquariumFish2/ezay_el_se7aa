import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../helpers/data_lists.dart';
import '../../../../model/patient.dart';

class StateDropDownButton extends StatelessWidget {
  const StateDropDownButton({
    Key? key,
    required this.label,
    required this.items,
  }) : super(key: key);

  final String label;
  final List items;
  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<Patient>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            width: 1,
            color: Colors.greenAccent,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
          child: DropdownButton(
            onTap: () => FocusScope.of(context).unfocus(),
            underline: Container(),
            isExpanded: true,
            style: TextStyle(
              color: Colors.green,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            hint: Text(
              label,
            ),
            value: patientProvider.state,
            items: items
                .map(
                  (e) => DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  ),
                )
                .toList(),
            onChanged: (v) {
              patientProvider.setState(v as String);
            },
          ),
        ),
      ),
    );
  }
}
