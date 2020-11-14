import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_editor/image_editor.dart';
import 'package:image/image.dart' as imgLib;

import '../resource/img_path.dart';

class ImageEditScreen extends StatefulWidget {
  static const routeName = '/img-edit-screen';

  @override
  _ImageEditScreenState createState() => _ImageEditScreenState();
}

class _ImageEditScreenState extends State<ImageEditScreen> {
  ImageProvider image;
  BlendMode blendMode = BlendMode.srcOver;
  File _selectedImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      _selectedImage = ModalRoute.of(context).settings.arguments;
      image = MemoryImage(_selectedImage.readAsBytesSync());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // File _selectedImage = ModalRoute.of(context).settings.arguments;
    // MemoryImage(_selectedImage.readAsBytesSync());
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit picture'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Center(
            child: GestureDetector(
                child: Container(
                  width: 400,
                  height: 500,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  child: image != null
                      ? Image(
                          image: image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : Text(
                          'No Image Taken',
                          textAlign: TextAlign.center,
                        ),
                  alignment: Alignment.center,
                ),
                onTapDown: (TapDownDetails details) =>
                    mixImage(context, _selectedImage, details)),
          ),
          DropdownButton<BlendMode>(
            items:
                supportBlendModes.map((BlendMode e) => _buildItem(e)).toList(),
            value: blendMode,
            onChanged: (value) {
              setState(() {
                blendMode = value;
              });
            },
          ),
          RaisedButton(
            child: Text('Mix'),
            onPressed: () {
              // mixImage(_selectedImage);
            },
          )
        ],
      ),
    );
  }

  _onTapDown(TapDownDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    print(details.localPosition);
    print("tap down:" + x.toString() + "," + y.toString());
  }

  DropdownMenuItem<BlendMode> _buildItem(BlendMode e) {
    return DropdownMenuItem<BlendMode>(
      child: Text(e.toString()),
      value: e,
    );
  }

  Future<void> mixImage(
      BuildContext context, File srcImg, TapDownDetails details) async {
    final Uint8List src = srcImg.readAsBytesSync();
    final Uint8List material = await loadFromAsset(ImgPaths.SUNGLASS_PNG);
    final ImageEditorOption optionGroup = ImageEditorOption();

    final Image img = Image.file(srcImg);
    print('${img.width.toString()}, ${img.height.toString()}');

    RenderBox getBox = context.findRenderObject();

    var localPos = getBox.globalToLocal(details.globalPosition);
    int x = localPos.dx.toInt();
    int y = localPos.dy.toInt();

    print("$x,$y");

    optionGroup.outputFormat = const OutputFormat.png();
    optionGroup.addOption(
      MixImageOption(
        x: x,
        y: y,
        width: 150,
        height: 150,
        target: MemoryImageSource(material),
        blendMode: blendMode,
      ),
    );
    final Uint8List result =
        await ImageEditor.editImage(image: src, imageEditorOption: optionGroup);
    image = MemoryImage(result);
    setState(() {});
  }

  Future<Uint8List> loadFromAsset(String key) async {
    final ByteData byteData = await rootBundle.load(key);
    return byteData.buffer.asUint8List();
  }
}
