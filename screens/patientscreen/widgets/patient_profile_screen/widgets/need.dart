import 'package:flutter/material.dart';

class Need extends StatelessWidget {
  const Need({
    Key? key,
    required this.needName,
    required this.needCost,
  }) : super(key: key);
  final String needName;
  final String needCost;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                needName,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )),
              Text(
                needCost,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
