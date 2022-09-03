import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../provider/normalPost.dart';
import '../../../../screens/postscreen/posts/normal_post.dart';

import 'comment.dart';

class GetAllComments extends StatelessWidget {
  GetAllComments(this.postId, this.comments, this.data, {Key? key})
      : super(key: key);
  final String postId;
  final CommentsType comments;
  final Map data;

  bool once = true;
  @override
  Widget build(BuildContext context) {
    if (once) {
      final prove = Provider.of<NormalPostProvider>(context, listen: false);
      int indexVision = 0;
      if (prove.indexVision != 0) {
        indexVision = prove.indexVision;
      } else {
        if (comments == CommentsType.undetail) {
          if (data.length > 2) {
            indexVision = 2;
          } else {
            indexVision = data.length - 1;
          }
        } else {
          if (data.length > 8)
            indexVision = 8;
          else
            indexVision = data.length - 1;
        }
        prove.indexVision = indexVision;
      }
      once = false;
    }

    final normalPostProve = Provider.of<NormalPostProvider>(context);
    Map current = {};
    for (int i = 0; i < normalPostProve.indexVision; i++)
      current.putIfAbsent(
          data.keys.elementAt(i), () => data.values.elementAt(i));
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        reverse: true,
        itemCount: normalPostProve.indexVision + 2,
        itemBuilder: (ctx, i) {
          return (i == current.length + 1)
              ? ((normalPostProve.indexVision != data.length)
                  ? TextButton(
                      child: Text('see more'),
                      onPressed: () {
                        if (comments == CommentsType.undetail) {
                          (data.length - normalPostProve.indexVision > 2)
                              ? normalPostProve.setIndexVision(
                                  normalPostProve.indexVision + 2)
                              : normalPostProve.setIndexVision(data.length);
                        } else {
                          (data.length - normalPostProve.indexVision > 8)
                              ? normalPostProve.setIndexVision(
                                  normalPostProve.indexVision + 8)
                              : normalPostProve.setIndexVision(data.length);
                        }
                      },
                    )
                  : Container())
              : (i == 0)
                  ? ((comments == CommentsType.detail &&
                              (normalPostProve.indexVision !=
                                  ((data.length > 8) ? 8 : data.length - 1))) ||
                          (comments == CommentsType.undetail &&
                              (normalPostProve.indexVision !=
                                  ((data.length > 2) ? 2 : data.length - 1)))
                      ? TextButton(
                          onPressed: () {
                            normalPostProve.setIndexVision((comments ==
                                    CommentsType.undetail)
                                ? ((data.length > 2) ? 2 : data.length - 1)
                                : ((data.length > 8) ? 8 : data.length - 1));
                          },
                          child: Text('undo'))
                      : Container())
                  : Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ),
                      ),
                      child: Comment(
                        latest: false,
                        comment: current.values.elementAt(i - 1),
                      ),
                    );
        });
  }
}
