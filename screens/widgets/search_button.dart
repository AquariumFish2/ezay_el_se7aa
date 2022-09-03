import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({Key? key, required this.onPressed}) : super(key: key);
  final onPressed;
  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed, icon: Icon(Icons.search));
  }
}
