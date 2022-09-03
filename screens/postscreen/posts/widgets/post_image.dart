import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../../../screens/postscreen/posts/widgets/hero_screen.dart';

class PostImage extends StatelessWidget {
  const PostImage({
    required Key? key,
    required this.imagePath,
    required this.images,
  }) : super(key: key);
  final String imagePath;
  final List images;
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
    return FutureBuilder(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HeroScreen(
                          tag: snapshot.data as String,
                          images: images,
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: super.key as UniqueKey,
                    child: Image.network(
                      snapshot.data as String,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
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
              ),
            );
          return Text(
            'refresh again please!',
            style: TextStyle(color: Colors.red),
          );
        });
  }
}
