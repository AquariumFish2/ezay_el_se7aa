import 'package:flutter/material.dart';
import '../../../screens/patientscreen/widgets/patient_profile_screen/widgets/need.dart';

class GuestTile extends StatelessWidget {
  const GuestTile({Key? key, required this.guestPatients}) : super(key: key);
  final Map guestPatients;
  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListView.builder(
      shrinkWrap: true,
      itemCount: guestPatients.length,
      itemBuilder: (ctx, i) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...(guestPatients[i]['costs'] as List)
              .map(
                (e) => Need(
                  needName: e['التكليف'],
                  needCost: e['القيمة'],
                ),
              )
              .toList(),
        ],
      ),
    ));
  }
}
