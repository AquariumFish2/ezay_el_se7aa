import 'package:docs/screens/profile_screen/widgets/profile_circle_avatar.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  //TODO get the user data from the class User you will create
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: ListView(
        children: const [ProfileCircleAvatar()],
      ),
    );
  }
}
