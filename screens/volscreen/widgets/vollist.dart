import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/volanteer.dart';
import '../../../provider/volanteers.dart';
import '../../../screens/volscreen/widgets/vollisttile.dart';

class VolList extends StatefulWidget {
  const VolList({Key? key}) : super(key: key);

  @override
  State<VolList> createState() => _VolListState();
}

class _VolListState extends State<VolList> {
  bool search = false;
  List<Volanteer> searchedVols = [];
  @override
  Widget build(BuildContext context) {
    final volanteers = Provider.of<Volanteers>(context);
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            setState(
              () {
                search = !search;
              },
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search),
              Text((!search) ? 'search' : 'back'),
            ],
          ),
        ),
        if (search)
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'ادخل اسم المتطوع او الفريق او رقم الهاتف',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 15),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green.shade50.withOpacity(.2),
                        borderRadius: BorderRadius.circular(15),
                        border:
                            Border.all(width: 1, color: Colors.green.shade400)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 10),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            searchedVols = volanteers.vols.where((element) {
                              bool t = false;
                              if (element.name != null) if (element.name!
                                  .toLowerCase()
                                  .contains(value)) t = true;
                              if (element.team != null) if (element.team!
                                  .contains(value)) t = true;
                              if (element.phone != null) if (element.phone!
                                  .contains(value)) t = true;
                              return t;
                            }).toList();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'كلمة البحث',
                          suffixIcon: Icon(
                            Icons.search,
                            color: Colors.green[200],
                          ),
                          hintStyle: TextStyle(color: Colors.green[200]),
                          // label: Text(label),

                          border: InputBorder.none,
                          errorBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: searchedVols
                        .map(
                          (e) => VolListTile(
                            volanteer: e,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        if (!search)
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: volanteers.vols
                  .map(
                    (e) => VolListTile(
                      volanteer: e,
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}
