import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../provider/docs/docs.dart';

import '../../model/doc.dart';

class ItemsSearchedInDocs extends ChangeNotifier {
  List<Doc> searchedDoctors = [];
  searchItems(String value, BuildContext context) {
    searchedDoctors = context.read<Docs>().doctors.where((element) {
      return element.name.toLowerCase().contains(value);
    }).toList();
    print(searchedDoctors);
    notifyListeners();
  }
}
