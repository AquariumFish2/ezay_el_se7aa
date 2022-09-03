import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/doc.dart';
import '../../provider/docs/docs.dart';
import '../../provider/docs/expand_docSample.dart';
import '../../provider/docs/searchDocController.dart';
import '../../screens/docscreen/add_doc.dart';
import '../../screens/widgets/app_bar_button.dart';
import 'package:sizer/sizer.dart';
import '../../provider/docs/itemsSearchedInDocs.dart';
import 'widgets/doc_sample.dart';

class DocList extends StatelessWidget {
  const DocList({Key? key}) : super(key: key);

  //List<Doc> searchedDoctors = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<SearchDocController>(
            builder: ((context, value, child) =>
                Text((value.search) ? 'البحث' : 'الدكاترة'))),
        actions: [
          Consumer<SearchDocController>(
            builder: ((context, value, child) {
              if (value.search)
                return IconButton(
                    onPressed: () {
                      print('setState refresh docs false');
                      value.setSearch(false);
                    },
                    icon: Icon(Icons.arrow_back));
              else
                return IconButton(
                    onPressed: () {
                      print('setState refresh docs true');
                      value.setSearch(true);
                    },
                    icon: Icon(Icons.search));
            }),
          ),
          Consumer<SearchDocController>(
            builder: (context, value, child) => (value.search)
                ? Container()
                : AppBarButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddDoctor(Doc()),
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: Container(
        height: 100.h,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: Image.asset(
                'assets/background.png',
                fit: BoxFit.fill,
                width: 100.w,
              ),
            ),
            LayoutBuilder(builder: (context, cons) {
              print('docsPage docProviders refreshed');
              return (context.watch<Docs>().doctors.isNotEmpty)
                  ? SingleChildScrollView(
                      child: Consumer<SearchDocController>(
                        builder: (context, value, child) {
                          return Column(children: [
                            if (value.search)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 15),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color:
                                          Colors.green.shade50.withOpacity(.2),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          width: 1,
                                          color: Colors.green.shade400)),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                onChanged: (value) {
                                                  context
                                                      .read<
                                                          ItemsSearchedInDocs>()
                                                      .searchItems(
                                                          value, context);
                                                },
                                                decoration: InputDecoration(
                                                  hintText: 'اسم الدكتور',
                                                  suffixIcon: Icon(
                                                    Icons.search,
                                                    color: Colors.green[200],
                                                  ),
                                                  hintStyle: TextStyle(
                                                      color: Colors.green[200]),
                                                  // label: Text(label),

                                                  border: InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
                                                  focusedErrorBorder:
                                                      InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (!value.search)
                              ...List.generate(
                                context.watch<Docs>().doctors.length,
                                (index) {
                                  return ChangeNotifierProvider(
                                    create: (context) => ExpandDocSample(),
                                    builder: (context, snapshot) {
                                      return DocSample(
                                          context.watch<Docs>().doctors[index]);
                                    },
                                  );
                                },
                              ).toList(),
                            if (value.search)
                              ...context
                                  .watch<ItemsSearchedInDocs>()
                                  .searchedDoctors
                                  .map(
                                    (e) => ChangeNotifierProvider(
                                      create: (context) => ExpandDocSample(),
                                      key: Key(e.Id as String),
                                      builder: (context, snapshot) {
                                        return DocSample(e);
                                      },
                                    ),
                                  ),
                          ]);
                        },
                      ),
                    )
                  : Container(
                      height: cons.maxHeight,
                      child: Center(child: Text('لا توجد دكاتره')),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
