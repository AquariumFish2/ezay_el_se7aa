import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../screens/postscreen/posts/widgets/last_post_image.dart';
import '../../../screens/postscreen/posts/widgets/post_image.dart';
import 'package:sizer/sizer.dart';

class ImportantPost extends StatelessWidget {
  ImportantPost({
    Key? key,
    required this.date,
    required this.text,
    required this.volName,
    this.images,
  }) : super(key: key);
  final String volName;
  final DateTime date;
  final String text;

  List? images;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                volName,
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
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
                          images: images as List,
                          key: UniqueKey(),
                          imagePath: images![0],
                        )
                      : (images!.length == 2)
                          ? Row(
                              children: images!.map((e) {
                                return Expanded(
                                  flex: 1,
                                  child: PostImage(
                                    images: images as List,
                                    key: UniqueKey(),
                                    imagePath: e,
                                  ),
                                );
                              }).toList(),
                            )
                          : (images!.length == 3)
                              ? Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: PostImage(
                                          images: images as List,
                                          key: UniqueKey(),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              PostImage(
                                                images: images as List,
                                                imagePath: images![1],
                                                key: UniqueKey(),
                                              ),
                                              LastPostImage(
                                                important: true,
                                                imagePath: images![2],
                                                images: images as List,
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  : Container()
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
