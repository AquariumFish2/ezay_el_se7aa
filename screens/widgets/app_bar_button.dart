import 'package:flutter/material.dart';

class AppBarButton extends StatelessWidget {
  const AppBarButton({Key? key, required this.onPressed}) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final onPressed;
  @override
  Widget build(BuildContext context) {
    double? f = Scaffold.of(context).appBarMaxHeight;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Icon(
          Icons.add,
          size: 18,
          color: Theme.of(context).primaryColor,
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          maximumSize: MaterialStateProperty.all(
            Size((f as double) - 10, (f) - 10),
          ),
          minimumSize: MaterialStateProperty.all(
            Size((f) - 50, (f) - 50),
          ),
        ),
      ),
    );
  }
}
