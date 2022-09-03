import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../model/user.dart';
import '../../../provider/bottom_navigationController.dart';

import '../../../screens/widgets/custom_text_field.dart';
import 'package:sizer/sizer.dart';

class PostsAddScreen extends StatefulWidget {
  PostsAddScreen({Key? key}) : super(key: key);

  @override
  State<PostsAddScreen> createState() => _PostsAddScreenState();
}

class _PostsAddScreenState extends State<PostsAddScreen> {
  final postsAddFormKey = GlobalKey<FormState>();

  final textController = TextEditingController();

  final voteController = TextEditingController();

  final textKey = Key('gdsagdsgsa');

  final voteKey = Key('voteKey');

  Future<void> save(
    BuildContext context,
    String id,
    String volName,
  ) async {
    if (postsAddFormKey.currentState!.validate() && postTypeValue != null ||
        (postsAddFormKey.currentState!.validate() &&
            postTypeValue == 'تصويت' &&
            votes.length < 2)) {
      // postsAddFormKey.currentState!.save();
      final database = FirebaseDatabase.instance;
      final store = FirebaseStorage.instance;
      List<String> imagesId = [];
      files.forEach((element) async {
        final fileId = DateTime.now().toString();
        imagesId.add('${id}_$fileId');
        await store.ref('posts/${id}_$fileId').putFile(element as File);
      });
      final ref = database.ref().child('posts').push();
      await database.ref().child(ref.path).update({
        'votes': (postTypeValue == 'تصويت')
            ? {'named': votes, 'selected': {}}
            : null,
        'volName': volName,
        'date': DateTime.now().toString(),
        'images': imagesId,
        'type': (postTypeValue == 'عادي')
            ? 'normal'
            : (postTypeValue == 'هام')
                ? 'important'
                : 'pole',
        'text': textController.text,
        'deadLine': DateTime.now().add(Duration(days: 7)).toString(),
        'acountId': curentUser.id
      });
      Navigator.pop(context);
      context
          .read<BottomNavigationController>()
          .setIndex(context.watch<BottomNavigationController>().index);
    }
  }

  Future pickImage(bool galery) async {
    List? images;

    if (galery)
      images = await ImagePicker().pickMultiImage();
    else
      images = [await ImagePicker().pickImage(source: ImageSource.camera)];
    if (images != null)
      images.forEach((element) {
        if (element != null) files.add(File((element as XFile).path));
      });
    setState(() {});
  }

  List postType = ['عادي', 'هام', 'تصويت'];

  List files = [];
  List votes = [];
  String? postTypeValue;

  @override
  Widget build(BuildContext context) {
    //ناقص هنا تضيف السيف فانكشن
    //و ال statemanagment

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Form(
          key: postsAddFormKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(width: 1, color: Colors.greenAccent)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton(
                        onTap: () => FocusScope.of(context).unfocus(),
                        isExpanded: true,
                        value: postTypeValue,
                        hint: Text('نوع المنشور ؟'),
                        items: postType
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        underline: Container(),
                        onChanged: (v) {
                          setState(() {
                            postTypeValue = v as String;
                          });
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 12.0),
                  child: Text(
                    'ادخل المحتوي الكتابي :',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                AddPatientTextField(
                    label: 'النص',
                    controller: textController,
                    tKey: textKey,
                    save: (v) {},
                    validate: (String v) {
                      if (v.isEmpty) return 'ادخل النص من فضلك';
                    },
                    multiline: true),
                (postTypeValue != 'تصويت')
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 12.0),
                        child: Text(
                          'اضف صورة ان اردت',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Text('اضف تصويت'),
                (postTypeValue != 'تصويت')
                    ? GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    child: Column(
                                      children: [
                                        Card(
                                          child: IconButton(
                                            onPressed: () async {
                                              await pickImage(true);
                                              Navigator.of(context).pop();
                                            },
                                            icon: Icon(Icons.image),
                                          ),
                                        ),
                                        Card(
                                          child: IconButton(
                                            onPressed: () async {
                                              await pickImage(false);
                                              Navigator.of(context).pop();
                                            },
                                            icon: Icon(Icons.camera),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                        },
                        child: (files.isEmpty)
                            ? Container(
                                width: 100.w,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(15)),
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 36,
                                ),
                              )
                            : GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: files.length,
                                itemBuilder: (ctx, i) => LayoutBuilder(
                                    builder: (context, constrain) {
                                  return Stack(
                                    children: [
                                      Container(
                                        height: constrain.maxHeight,
                                        width: constrain.maxWidth,
                                        child: Image.file(
                                          files[i],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: GestureDetector(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.black54,
                                              ),
                                              padding: EdgeInsets.all(4),
                                              child: Icon(
                                                Icons.cancel_outlined,
                                                size: 2.h,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                files.remove(files[i]);
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                              ),
                      )
                    : Column(
                        children: [
                          ...votes.map(
                            (e) => Container(
                              padding: const EdgeInsets.all(6),
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.greenAccent,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    e,
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        votes.remove(e);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: AddPatientTextField(
                                    label: 'تصويت',
                                    controller: voteController,
                                    tKey: voteKey,
                                    save: () {},
                                    validate: (v) {
                                      // if ((v as String).isEmpty)
                                      //   return 'ادخل نص من فضلك';
                                    },
                                    multiline: false),
                              ),
                              Expanded(
                                  child: IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (voteController.text.isNotEmpty) {
                                      votes.add(
                                        voteController.text,
                                      );
                                      voteController.clear();
                                    }
                                  });
                                },
                              ))
                            ],
                          )
                        ],
                      ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => save(
                          context,
                          curentUser.id as String,
                          curentUser.name as String,
                        ),
                        child: Text('اضف المنشور'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
