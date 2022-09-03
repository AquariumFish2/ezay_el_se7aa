import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/doc.dart';
import '../../../provider/docs/expand_docSample.dart';
import '../../../screens/docscreen/add_doc.dart';

class DocSample extends StatelessWidget {
  DocSample(this.doc, {Key? key});

  final Doc doc;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceOut,
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.blue.shade100.withOpacity(.3),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              width: 2,
              color: (doc.agreed) ? Colors.green.shade600 : Colors.red.shade300,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc.name,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              height: 1),
                        ),
                        Text(
                          '${doc.phone}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                          ),
                        ),
                        if (doc.email != '')
                          Text(
                            'الايميل :${doc.email}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                            ),
                          ),
                        Text(
                          'التخصص :${doc.classification}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      iconSize: 16,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => AddDoctor(doc),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (context.watch<ExpandDocSample>().expand)
              Text(
                doc.hint,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                ),
              ),
            if (context.watch<ExpandDocSample>().expand)
              Column(
                children: [
                  ...doc.patients
                      .map((e) => Container(
                            color: Colors.green[800],
                            child: Row(
                              children: [
                                Text(
                                  e['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.green,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  e['illness'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList()
                ],
              ),
            if (doc.hint != '' || doc.patients.isEmpty)
              IconButton(
                onPressed: () {
                  context.read<ExpandDocSample>().setExpand();
                },
                splashRadius: 0.1,
                padding: EdgeInsets.zero,
                icon: (!context.watch<ExpandDocSample>().expand)
                    ? const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.green,
                      )
                    : const Icon(
                        Icons.arrow_drop_up,
                        color: Colors.green,
                      ),
              )
          ],
        ),
      ),
    );
  }
}
