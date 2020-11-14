import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

import '../screens/img_edit_screen.dart';

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;
  final picker = ImagePicker();

  Future<void> _takePicture() async {
    final imageFile = await picker.getImage(
      source: ImageSource.camera,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await _storedImage.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  Future<void> _getImageFromGallery() async {
    final imageFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await _storedImage.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 400,
          height: 480,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: FlatButton.icon(
                icon: Icon(Icons.photo_camera),
                label: Text('カメラ'),
                textColor: Theme.of(context).primaryColor,
                onPressed: _takePicture,
              ),
            ),
            Expanded(
              child: FlatButton.icon(
                icon: Icon(Icons.photo_library),
                label: Text('ギャラリー'),
                textColor: Theme.of(context).primaryColor,
                onPressed: _getImageFromGallery,
              ),
            ),
            _storedImage != null
                ? Expanded(
                    child: RaisedButton(
                      child: Text(
                        '選択',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            ImageEditScreen.routeName,
                            arguments: _storedImage);
                      },
                    ),
                  )
                : Container()
          ],
        ),
      ],
    );
  }
}
