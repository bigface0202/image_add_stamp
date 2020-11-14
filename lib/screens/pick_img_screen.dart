import 'dart:io';

import 'package:flutter/material.dart';

import '../widgets/image_input.dart';

class PickImgScreen extends StatefulWidget {
  static const routeName = '/pick-img-screen';

  @override
  _PickImgScreenState createState() => _PickImgScreenState();
}

class _PickImgScreenState extends State<PickImgScreen> {
  File _pickedImage;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select picture'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    ImageInput(_selectImage),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
