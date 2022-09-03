import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../model/patient.dart';
import '../../../../../screens/patientscreen/widgets/patient_profile_screen/widgets/images_edit_dialog.dart';
import 'package:sizer/sizer.dart';

class ImagesList extends StatelessWidget {
  ImagesList({
    Key? key,
  }) : super(
          key: key,
        );
  List<String> imagesUrl = [];
  @override
  Widget build(BuildContext context) {
    final patient = Provider.of<Patient>(context);

    Future<void> getImagesUrl() async {
      for (String image in patient.images) {
        final file = await FirebaseStorage.instance
            .ref()
            .child('posts')
            .child(image)
            .getDownloadURL();
        imagesUrl.add(file);
      }
      print(imagesUrl);
    }

    return FutureBuilder<void>(
        future: getImagesUrl(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          print(imagesUrl);
          if (imagesUrl.length != 0) {
            final List<String> images = imagesUrl;
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        'صور الحالة',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        //هنا التعديل
                        showDialog(
                          context: context,
                          builder: (context) =>
                              ImagesEditDialog(images: images),
                        );
                      },
                    )
                  ],
                ),
                Container(
                  width: 100.w,
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemCount: images.length,
                    itemBuilder: (BuildContext context, int index) => Container(
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        //color: Colors.white,
                        border: Border.all(width: 0.5, color: Colors.black),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            images[index],
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                ),
              ],
            );
          }
          return Container();
        });
  }
}
