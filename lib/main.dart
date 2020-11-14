import 'package:flutter/material.dart';

import './screens/index_screen.dart';
import './screens/pick_img_screen.dart';
import './screens/img_edit_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image editor',
      theme: ThemeData(
        primaryColor: Colors.pinkAccent,
      ),
      home: IndexScreen(),
      routes: {
        PickImgScreen.routeName: (ctx) => PickImgScreen(),
        ImageEditScreen.routeName: (ctx) => ImageEditScreen(),
      },
    );
  }
}
