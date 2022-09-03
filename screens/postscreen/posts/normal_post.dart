import 'dart:async';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../model/user.dart';
import '../../../provider/bottom_navigationController.dart';

import '../../../provider/normalPost.dart';
import '../../../screens/postscreen/posts/widgets/comment_text_field.dart';
import '../../../screens/postscreen/posts/widgets/getAllcomments.dart';
import '../../../screens/postscreen/posts/widgets/last_post_image.dart';
import '../../../screens/postscreen/posts/widgets/post_image.dart';
import 'package:sizer/sizer.dart';

enum CommentsType {
  detail,
  undetail,
}

class NormalPost extends StatelessWidget {
  NormalPost({
    Key? key,
    required this.date,
    required this.text,
    required this.volName,
    required this.comments,
    required this.postId,
    required this.accountId,
    this.images,
  }) : super(key: key);
  final String volName;
  final String postId;
  final DateTime date;
  final String text;
  final String accountId;
  CommentsType comments;
  List? images;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NormalPostProvider(),
      child: Card(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            volName,
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          if (curentUser.id == accountId)
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                            title: Text('are you sure'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () async {
                                                    await FirebaseDatabase
                                                        .instance
                                                        .ref()
                                                        .child('posts')
                                                        .child(postId)
                                                        .set(null);
                                                    await FirebaseDatabase
                                                        .instance
                                                        .ref()
                                                        .child('posts')
                                                        .child('seen')
                                                        .child(postId)
                                                        .set(null);
                                                    await FirebaseDatabase
                                                        .instance
                                                        .ref()
                                                        .child('posts')
                                                        .child('comment')
                                                        .child(postId)
                                                        .set(null);
                                                    images!.forEach(
                                                        (element) async {
                                                      await FirebaseStorage
                                                          .instance
                                                          .ref()
                                                          .child('posts')
                                                          .child(element)
                                                          .delete();
                                                    });
                                                    Navigator.of(ctx).pop();
                                                    context
                                                        .read<
                                                            BottomNavigationController>()
                                                        .setIndex(context
                                                            .watch<
                                                                BottomNavigationController>()
                                                            .index);
                                                  },
                                                  child: Text('yes')),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: Text('No!')),
                                            ],
                                          ));
                                },
                                icon: Icon(
                                  Icons.transit_enterexit,
                                  color: Colors.red,
                                ))
                        ],
                      ),
                      Text(
                        DateFormat('hh:mm  d/M/y').format(date),
                        style: TextStyle(
                          color: Colors.grey[400],
                        ),
                      ),
                      Text(
                        '$text',
                        textWidthBasis: TextWidthBasis.longestLine,
                      ),
                      (images != null)
                          ? (images!.length == 1)
                              ? PostImage(
                                  key: UniqueKey(),
                                  imagePath: images![0],
                                  images: images as List,
                                )
                              : (images!.length == 2)
                                  ? Row(
                                      children: images!
                                          .map((e) => Expanded(
                                                flex: 1,
                                                child: PostImage(
                                                  images: images as List,
                                                  key: UniqueKey(),
                                                  imagePath: e,
                                                ),
                                              ))
                                          .toList(),
                                    )
                                  : (images!.length == 3)
                                      ? Row(
                                          children: [
                                            Expanded(
                                                flex: 2,
                                                child: PostImage(
                                                  key: UniqueKey(),
                                                  images: images as List,
                                                  imagePath: images![0],
                                                )),
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                children: [
                                                  PostImage(
                                                    images: images as List,
                                                    key: UniqueKey(),
                                                    imagePath: images![1],
                                                  ),
                                                  PostImage(
                                                    images: images as List,
                                                    key: UniqueKey(),
                                                    imagePath: images![2],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      : (images!.length > 3)
                                          ? Row(
                                              children: [
                                                Expanded(
                                                    flex: 2,
                                                    child: PostImage(
                                                      images: images as List,
                                                      imagePath: images![0],
                                                      key: UniqueKey(),
                                                    )),
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    children: [
                                                      PostImage(
                                                        images: images as List,
                                                        imagePath: images![1],
                                                        key: UniqueKey(),
                                                      ),
                                                      LastPostImage(
                                                        important: false,
                                                        images: images as List,
                                                        imagePath: images![2],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          : Container()
                          : Container(),
                      StreamBuilder<DatabaseEvent>(
                        stream: FirebaseDatabase.instance
                            .ref()
                            .child('posts')
                            .child('seen')
                            .child(postId)
                            .onValue,
                        builder: (context, snap) {
                          if (snap.data != null) {
                            if (snap.data!.snapshot.value != null) {
                              int numSeen = 0;
                              (snap.data!.snapshot.value as Map).forEach(
                                (key, value) => (value) ? numSeen++ : null,
                              );
                              return TextButton(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(numSeen.toString()),
                                    Icon(Icons.star),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Scaffold(
                                        appBar: AppBar(),
                                        body: FutureBuilder<DataSnapshot>(
                                          future: FirebaseDatabase.instance
                                              .ref()
                                              .child('users')
                                              .get(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting)
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            if (snapshot.data !=
                                                null) if (snapshot
                                                    .data!.value !=
                                                null)
                                              return SingleChildScrollView(
                                                child: Column(
                                                  children: (snap.data!.snapshot
                                                          .value as Map)
                                                      .keys
                                                      .toList()
                                                      .where((element) => (snap
                                                                  .data!
                                                                  .snapshot
                                                                  .value
                                                              as Map)[element]
                                                          as bool)
                                                      .toList()
                                                      .map((e) => Row(
                                                            children: [
                                                              Text((snapshot
                                                                          .data!
                                                                          .value
                                                                      as Map)[e]
                                                                  ['userName']),
                                                              Spacer(),
                                                              Text(
                                                                (snapshot.data!
                                                                            .value
                                                                        as Map)[
                                                                    e]['phone'],
                                                              ),
                                                            ],
                                                          ))
                                                      .toList(),
                                                ),
                                              );
                                            return Container();
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          }
                          return Container();
                        },
                      ),
                      Divider(),
                      Container(
                        height: 5.h,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Colors.white.withOpacity(0),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => Scaffold(
                                            appBar: AppBar(),
                                            body: NormalPost(
                                              accountId: accountId,
                                              comments: CommentsType.detail,
                                              postId: postId,
                                              date: date,
                                              text: text,
                                              volName: text,
                                              images: images,
                                            ),
                                          )));
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('كومنت'),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Icon(Icons.message),
                                  ],
                                ),
                              ),
                            ),
                            VerticalDivider(),
                            Expanded(
                                child: TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.white.withOpacity(0),
                                ),
                              ),
                              onPressed: () async {
                                dynamic val = await FirebaseDatabase.instance
                                    .ref()
                                    .child('posts')
                                    .child('seen')
                                    .child(postId)
                                    .child(curentUser.id as String)
                                    .get();
                                if (val.value == null)
                                  val = false;
                                else
                                  val = val.value;
                                await FirebaseDatabase.instance
                                    .ref()
                                    .child('posts')
                                    .child('seen')
                                    .child(postId)
                                    .child(curentUser.id as String)
                                    .set(!val);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  //bool read
                                  //(read)?
                                  StreamBuilder<DatabaseEvent>(
                                      stream: FirebaseDatabase.instance
                                          .ref()
                                          .child('posts')
                                          .child('seen')
                                          .child(postId)
                                          .child(curentUser.id as String)
                                          .onValue,
                                      builder: (context, snapshot) {
                                        if (snapshot.data != null) {
                                          if (snapshot.data!.snapshot.value !=
                                              null) {
                                            if ((snapshot.data!.snapshot.value
                                                    as bool) ==
                                                true) return Icon(Icons.star);
                                          }
                                        }
                                        return Icon(Icons.star_border);
                                      }),
                                  //:Icon(Icons.star),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text('قرأت'),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              (comments == CommentsType.undetail)
                  ? Divider(
                      height: 0,
                    )
                  : Container(),
              StreamBuilder<DatabaseEvent>(
                  stream: FirebaseDatabase.instance
                      .ref()
                      .child('posts')
                      .child('comment')
                      .child(postId)
                      .onValue,
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      if (snapshot.data!.snapshot.value != null) {
                        Map data = snapshot.data!.snapshot.value as Map;
                        var dataSorted = data.keys.toList()
                          ..sort((k1, k2) => DateTime.parse(data[k2]['date'])
                              .compareTo(DateTime.parse(data[k1]['date'])));
                        data = Map.fromIterable(dataSorted,
                            key: (e) => e, value: (e) => data[e]);
                        return GetAllComments(postId, comments, data);
                      }
                    }
                    return Container();
                  }),
              CommentTextField(postId),
            ],
          ),
        ),
      ),
    );
  }
}
