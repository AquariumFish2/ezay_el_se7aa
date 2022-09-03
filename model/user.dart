import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

UserData curentUser = UserData();

class UserData {
  String? id;
  String? team;
  String? name;
  String? email;
  String? phoneNumber;
  String? state;
  String? classification;
  bool? accepted;

  Future<bool> getDataFromApi() async {
    id = FirebaseAuth.instance.currentUser!.uid;
    if (id == null) return false;
    try {
      final data = await FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(id as String)
          .get();
      if (data.value == null) return false;
      name = (data.value as Map)['userName'];
      email = (data.value as Map)['email'];
      phoneNumber = (data.value as Map)['phone'];
      state = (data.value as Map)['state'];
      classification = (data.value as Map)['classification'];
      team = (data.value as Map)['team'];
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
