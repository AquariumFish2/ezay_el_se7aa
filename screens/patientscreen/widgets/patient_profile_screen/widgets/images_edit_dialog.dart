import 'package:flutter/material.dart';

class ImagesEditDialog extends StatelessWidget {
  const ImagesEditDialog({Key? key, required this.images}) : super(key: key);
  final List<String> images;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              child: Text(
                'الصور',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            GridView.builder(
              itemCount: images.length,
              shrinkWrap: true,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) => Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: EdgeInsets.all(4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        images[index],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: -4,
                    child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        //delete handle
                      },
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: IconButton(
                    icon: Icon(
                      Icons.add_a_photo,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      //زود صوره
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: ElevatedButton(
                  onPressed: () {},
                  child: Container(
                    child: Text('حفظ'),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
