import 'package:edit_picture/widgets/image_input.dart';
import 'package:flutter/material.dart';

import 'pick_img_screen.dart';

class IndexScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image editor'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(PickImgScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
