import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/volanteers.dart';
import '../../screens/volscreen/widgets/vollist.dart';
import 'package:sizer/sizer.dart';

class VolScreen extends StatelessWidget {
  const VolScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prove = Provider.of<Volanteers>(context, listen: false);

    print('ss');
    return Scaffold(
      appBar: AppBar(
        title: const Text('المتطوعين'),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: 100.w,
              child: Image.asset(
                'assets/background.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            width: 100.w,
            child: FutureBuilder(
                future: prove.refresh(context),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  return const VolList();
                }),
          ),
        ],
      ),
    );
  }
}
