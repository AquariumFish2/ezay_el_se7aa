import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../model/user.dart';
import '../../../provider/bottom_navigationController.dart';

import 'package:sizer/sizer.dart';

class VotePost extends StatelessWidget {
  const VotePost(
      {Key? key,
      required this.votes,
      required this.volName,
      required this.date,
      required this.text,
      required this.votsNameLists,
      required this.accountId,
      required this.postId})
      : super(key: key);
  final List votes;
  final String volName;
  final DateTime date;
  final String text;
  final String postId;
  final Map votsNameLists;
  final String accountId;
  //bool selected = false;
  // num total = 0;
  // void setTotal() {
  //   total = 0;
  //   widget.votes.forEach(
  //     (element) {
  //       setState(() {
  //         total += element['quantity'];
  //       });
  //     },
  //   );
  // }

  // @override
  // void initState() {
  //   setTotal();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final total = votsNameLists.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Text('No!')),
                                  TextButton(
                                      onPressed: () async {
                                        await FirebaseDatabase.instance
                                            .ref()
                                            .child('posts')
                                            .child(postId)
                                            .set(null);
                                        Navigator.of(ctx).pop();
                                        context
                                            .read<BottomNavigationController>()
                                            .setIndex(context
                                                .watch<
                                                    BottomNavigationController>()
                                                .index);
                                      },
                                      child: Text('yes')),
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
            DateFormat('hh:mm  dd/MM/yyyy').format(date),
            style: TextStyle(color: Colors.grey[400]),
          ),
          Text(text),
          ...votes
              .map(
                (e) => Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(15)),
                  margin: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Stack(
                          children: [
                            Positioned(
                              right: 0,
                              child: Container(
                                height: 6.h,
                                child: Center(
                                  child: Text(
                                    e,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: votsNameLists.values
                                      .where((element) => element == e)
                                      .length,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          bottomRight: Radius.circular(15)),
                                      color: Colors.green.withOpacity(.3),
                                    ),
                                    height: 6.h,
                                  ),
                                ),
                                Expanded(
                                  flex: (total -
                                      votsNameLists.values
                                          .where((element) => element == e)
                                          .length),
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              left: 0,
                              top: 0,
                              child: GestureDetector(
                                child: IconButton(
                                  splashRadius: 1.0,
                                  iconSize: 16,
                                  icon: (votsNameLists
                                              .containsKey(curentUser.id) &&
                                          votsNameLists[curentUser.id] == e)
                                      ? Icon(
                                          Icons.check_box,
                                          color: Colors.green,
                                        )
                                      : Icon(
                                          Icons.check_box_outline_blank,
                                          color: Colors.green,
                                        ),
                                  onPressed: () async {
                                    await FirebaseDatabase.instance
                                        .ref()
                                        .child('posts')
                                        .child(postId)
                                        .child('votes')
                                        .child('selected')
                                        .update({curentUser.id as String: e});
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ]),
      ),
    );
  }
}
