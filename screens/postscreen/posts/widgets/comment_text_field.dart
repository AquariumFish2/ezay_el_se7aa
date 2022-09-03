import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../model/user.dart';

import '../../../../provider/normalPost.dart';

class CommentTextField extends StatelessWidget {
  CommentTextField(this.postId, {Key? key}) : super(key: key);
  TextEditingController commentTextFieldController = TextEditingController();
  final postId;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(width: 1, color: Colors.greenAccent),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'اكتب تعليق',
                  border: InputBorder.none,
                  errorBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
                controller: commentTextFieldController,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.green,
            ),
            onPressed: () {
              final ref = FirebaseDatabase.instance
                  .ref()
                  .child('posts')
                  .child('comment')
                  .child(postId)
                  .push();

              FirebaseDatabase.instance.ref().child(ref.path).set({
                'date': DateTime.now().toString(),
                'name': curentUser.name,
                'content': commentTextFieldController.text,
              });
              commentTextFieldController.clear();
              FocusScope.of(context).unfocus();
              Provider.of<NormalPostProvider>(context, listen: false).addOne();
            },
          ),
        ),
      ],
    );
  }
}
