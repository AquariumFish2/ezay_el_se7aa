import 'package:flutter/material.dart';
import '../../../../screens/postscreen/posts/widgets/post_image.dart';

class HeroScreen extends StatelessWidget {
  HeroScreen({Key? key, required this.tag, required this.images})
      : super(key: key);
  final String tag;
  final List? images;
  PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الصور'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          PageView(
            controller: controller,
            children: [
              ...images!
                  .map(
                    (e) => PostImage(
                      key: UniqueKey(),
                      imagePath: e,
                      images: images as List,
                    ),
                  )
                  .toList()
            ],
          ),
          Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.black45),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    child: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                        controller.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.bounceIn);
                    },
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.black45),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    child: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.bounceIn);
                    },
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
