// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:sample/screens/guestscreen/widgets/guest_tile.dart';

// class GuestScreen extends StatefulWidget {
//   const GuestScreen(this.authanticated, {Key? key}) : super(key: key);
//   final bool authanticated;
//   @override
//   State<GuestScreen> createState() => _GuestScreenState();
// }

// class _GuestScreenState extends State<GuestScreen> {
//   List<Map> guestsPatients = [];

//   var _scaffoldKey = GlobalKey<ScaffoldState>();
//   @override
//   void initState() {
//     super.initState();
//     if (widget.authanticated)
//       WidgetsBinding.instance.addPostFrameCallback(
//         (_) => ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Welcome User'),
//           ),
//         ),
//       );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Future future() async {
//     //   // final docsPatients = await FirebaseDatabase.instance
//     //   //     .ref()
//     //   //     .child('patients')
//     //   //     .child('طب')
//     //   //     .get();
//     //   // final othersPatients = await FirebaseDatabase.instance
//     //   //     .ref()
//     //   //     .child('patients')
//     //   //     .child('صيدلة')
//     //   //     .get();
//     //   if (docsPatients.value != null) {
//     //     print(docsPatients.value);
//     //     (docsPatients.value as Map).values.forEach(
//     //       (element) {
//     //         if (element['availableForGuests']) {
//     //           setState(
//     //             () {
//     //               guestsPatients.add(element);
//     //             },
//     //           );
//     //         }
//     //       },
//     //     );
//     //   }
//     //   if (othersPatients.value != null) {
//     //     (othersPatients.value as Map).values.forEach(
//     //       (element) {
//     //         if (element['availableForGuests']) {
//     //           setState(
//     //             () {
//     //               guestsPatients.add(element);
//     //             },
//     //           );
//     //         }
//     //       },
//     //     );
//     //   }
//     //   print(guestsPatients);
//     // }

//     return Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           title: const Text('الحالات'),
//           actions: [
//             IconButton(
//                 onPressed: () => FirebaseAuth.instance.signOut(),
//                 icon: const Icon(Icons.logout))
//           ],
//         ),
//         body: FutureBuilder(
//           //future: future(),
//           builder: (context, snapshot) => ListView.builder(
//             itemCount: guestsPatients.length,
//             itemBuilder: (ctx, i) => Container(),
//             // GuestTile(
//             //       guestPatients: guestsPatients[i],
//             //     )
//             //     ),
//           ),
//         ));
//   }
// }
