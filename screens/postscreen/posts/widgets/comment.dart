import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Comment extends StatelessWidget {
  const Comment({Key? key, required this.comment, required this.latest})
      : super(key: key);
  final Map comment;
  final bool latest;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              child: Text(
                comment['name'],
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                ),
              ),
            ),
            Spacer(),
            Text(
              DateFormat('hh:mm')
                  .format(DateTime.parse(comment['date']))
                  .toString(),
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 18,
              ),
            ),
          ],
        ),
        Text(
          DateFormat('dd/MM/yyyy')
              .format(DateTime.parse(comment['date']))
              .toString(),
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 14,
          ),
        ),
        Text(
          comment['content'],
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        (!latest) ? Divider() : Container(),
      ],
    );
  }
}
