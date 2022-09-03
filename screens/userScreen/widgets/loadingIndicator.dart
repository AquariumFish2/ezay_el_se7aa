import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sizer/sizer.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({required this.label, required this.postion, Key? key})
      : super(key: key);
  final String label;
  final int postion;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(this.label),
          SizedBox(
            height: 5,
            width: 60.w,
            child: Row(
              children: [
                Expanded(
                    flex: postion,
                    child: Container(
                      color: Colors.green,
                    )),
                Expanded(
                    flex: 4 - postion,
                    child: Container(
                      color: Colors.grey[200],
                    ))
              ],
            ),
          )
        ]),
      ),
    );
  }
}
