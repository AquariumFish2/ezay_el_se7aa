import 'package:flutter/material.dart';

class InformationTile extends StatelessWidget {
  const InformationTile({
    Key? key,
    required this.information,
    required this.label,
  }) : super(key: key);
  final String label;
  final String information;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          width: 1,
          color: Colors.green,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.headline1,
            ),
            Spacer(),
            Text(information, style: Theme.of(context).textTheme.subtitle1)
          ],
        ),
      ),
    );
  }
}
