import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Auth extends ChangeNotifier {
  String? id;
  final auth = FirebaseAuth.instance;
  final database = FirebaseDatabase.instance;

  String? userClassificationDropDownBottonValue = 'غير محدد';
  setUserClassificationDropDownBottonValue(String v) {
    userClassificationDropDownBottonValue = v;
    notifyListeners();
  }

  String? roleDropDownBottonValue;
  setRoleDropDownBottonValue(String v) {
    roleDropDownBottonValue = v;
    notifyListeners();
  }

  String? stateDropDownBottonValue;
  setstateDropDownBottonValue(String v) {
    stateDropDownBottonValue = v;
    notifyListeners();
  }

  bool signIn = true;
  changeSigning() {
    signIn = !signIn;
    notifyListeners();
  }

  bool triedToValidate = false;
  toggleTriedToValidate() {
    triedToValidate = true;
    notifyListeners();
  }

  void signInFun(String email, String password, BuildContext context) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      id = auth.currentUser!.uid;
    } catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text((error as FirebaseAuthException).message.toString())));
    }
  }

  void register(
      {required String userName,
      required String userPhone,
      required String email,
      required String password,
      required bool thereAreUsers,
      required BuildContext context,
      required bool master}) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      id = auth.currentUser!.uid;
      await database.ref().child("users").child(id as String).set({
        'userName': userName,
        'phone': userPhone,
        'email': email,
        'state': stateDropDownBottonValue,
        'classification': userClassificationDropDownBottonValue,
        'role': (master) ? 'مسؤول الملف' : roleDropDownBottonValue,
        'team': 'مطلق'
      });
      await database
          .ref()
          .child('activation')
          .child(auth.currentUser!.uid)
          .set({
        //////edit to if not first user false
        'accepted': true,
      });
    } catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text((error as FirebaseAuthException).message.toString())));
    }
  }

  void guest(BuildContext context) {
    try {
      auth.signInAnonymously();
    } catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text((error as FirebaseAuthException).message.toString())));
    }
  }

  signOut() {
    auth.signOut();
  }
}
