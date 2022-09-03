import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screens/postscreen/posts/important_post.dart';
import '../../screens/postscreen/posts/normal_post.dart';
import '../../screens/postscreen/posts/vote_post.dart';
import '../../screens/postscreen/postsaddscreen/posts_add_screen.dart';
import '../../screens/widgets/app_bar_button.dart';
import 'package:sizer/sizer.dart';

class PostsScreen extends StatelessWidget {
  PostsScreen(this.posts, {Key? key}) : super(key: key);
  final List<Map<String, dynamic>> posts;
  @override
  Widget build(BuildContext context) {
    (posts).forEach((value) {
      print(value);
      if (DateTime.parse(value['deadLine']).isBefore(DateTime.now())) {
        FirebaseDatabase.instance
            .ref()
            .child('posts')
            .child(value['key'])
            .set(null);
        FirebaseDatabase.instance
            .ref()
            .child('posts')
            .child('seen')
            .child(value['key'])
            .set(null);
        FirebaseDatabase.instance
            .ref()
            .child('posts')
            .child('comment')
            .child(value['key'])
            .set(null);
        (value['images'] as List?)!.forEach((element) {
          FirebaseStorage.instance.ref().child('posts').child(element).delete();
        });
      }
    });
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text('البوستات'),
        actions: [
          ////edit
          // if (account.role != 'متطوع')
          AppBarButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => PostsAddScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: 100.w,
              child: Image.asset(
                'assets/background.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            width: 100.w,
            child: ListView(
              children: [
                if (posts.any((element) => element['type'] == 'important'))
                  Container(
                    height: 20.h,
                    child: Container(
                      width: 100.w,
                      child: ListView.builder(
                        cacheExtent: 10,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: posts.length,
                        itemBuilder: (ctx, i) => (posts[i]['type'] ==
                                'important')
                            ? StreamBuilder<DatabaseEvent>(
                                stream: FirebaseDatabase.instance
                                    .ref()
                                    .child('posts')
                                    .child(posts[i]['key'])
                                    .onValue,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting)
                                    return Center(child: LayoutBuilder(
                                        builder: (context, constrain) {
                                      return Container(
                                          height: 50.w,
                                          width: 50.w,
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()));
                                    }));
                                  if (snapshot.data != null) {
                                    Map data =
                                        snapshot.data!.snapshot.value as Map;
                                    if (snapshot.data!.snapshot.value != null)
                                      return Container(
                                        width: 50.w,
                                        child: ImportantPost(
                                          date: DateTime.parse(data['date']),
                                          text: data['text'],
                                          volName: data['volName'],
                                          images: (data['images'] == null)
                                              ? null
                                              : data['images'],
                                        ),
                                      );
                                  }
                                  return Container();
                                })
                            : Container(),
                      ),
                    ),
                  ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: posts.length,
                  itemBuilder: (ctx, i) => (posts[i]['type'] == 'normal' ||
                          posts[i]['type'] == 'important')
                      ? StreamBuilder<DatabaseEvent>(
                          stream: FirebaseDatabase.instance
                              .ref()
                              .child('posts')
                              .child(posts[i]['key'])
                              .onValue,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting)
                              return Container(
                                height: 20.h,
                                width: 20.h,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            if (snapshot.data != null) {
                              Map data = snapshot.data!.snapshot.value as Map;
                              if (snapshot.data!.snapshot.value != null)
                                return NormalPost(
                                  accountId: data['acountId'],
                                  date: DateTime.parse(data['date']),
                                  text: data['text'],
                                  volName: data['volName'],
                                  images: (data['images'] == null)
                                      ? null
                                      : data['images'],
                                  comments: CommentsType.undetail,
                                  postId: posts[i]['key'],
                                );
                            }
                            return Text('حدث خطأ في عرض ذلك البوست');
                          })
                      : (posts[i]['type'] == 'pole')
                          ? StreamBuilder<DatabaseEvent>(
                              stream: FirebaseDatabase.instance
                                  .ref()
                                  .child('posts')
                                  .child(posts[i]['key'])
                                  .onValue,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting)
                                  return Container(
                                    height: 20.h,
                                    width: 20.h,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );

                                if (snapshot.data != null) {
                                  Map data =
                                      snapshot.data!.snapshot.value as Map;
                                  if (snapshot.data!.snapshot.value != null)
                                    return VotePost(
                                      accountId: data['acountId'],
                                      votsNameLists:
                                          (data['votes']['selected'] == null)
                                              ? {}
                                              : data['votes']['selected'],
                                      votes: data['votes']['named'],
                                      volName: data['volName'],
                                      date: DateTime.parse(data['date']),
                                      text: data['text'],
                                      postId: posts[i]['key'],
                                    );
                                }
                                return Text('حدث خطأ في عرض ذلك البوست');
                              })
                          : Container(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
