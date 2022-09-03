import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../../../screens/postscreen/posts/widgets/hero_screen.dart';
import '../../../../screens/postscreen/posts/widgets/post_image.dart';
import 'package:sizer/sizer.dart';

class LastPostImage extends StatelessWidget {
  const LastPostImage(
      {Key? key,
      required this.imagePath,
      required this.images,
      required this.important})
      : super(key: key);
  final String imagePath;
  final List images;
  final bool important;
  Future<String?> getImage() async {
    final file = FirebaseStorage.instance
        .ref()
        .child('posts')
        .child(imagePath)
        .getDownloadURL();
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      FutureBuilder(
          future: getImage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Container(
                height: 300,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                ),
              );
            if (snapshot.data != null)
              return Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => Dialog(
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemCount: images.length,
                            itemBuilder: (ctx, i) => PostImage(
                              images: images as List,
                              imagePath: images[i],
                              key: UniqueKey(),
                              //   ),
                              // ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Image.network(
                      snapshot.data as String,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null)
                          return Stack(
                            children: [
                              child,
                              Positioned.fill(
                                child: LayoutBuilder(builder: (context, cons) {
                                  print(cons.maxHeight);
                                  return Container(
                                    width: cons.maxWidth,
                                    height: cons.maxHeight,
                                    // padding: EdgeInsets.symmetric(
                                    //     vertical: (important) ? 1.h : 2.5.h),
                                    // margin: EdgeInsets.symmetric(
                                    //     vertical: (important) ? 1.25.h : 5.2.h),
                                    color: Colors.black38,
                                    child: Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                          FittedBox(
                                              child: Text(
                                            (images.length - 3).toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              )
                            ],
                          );
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: LinearProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            return Text('no image with that url');
          })
    ]);
  }
}
