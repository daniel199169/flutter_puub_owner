import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PubCameraService {
  static File _image;
  static final picker = ImagePicker();
  static PickedFile _pickedFile;

  static Future<File> showPubDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Gallery"),
                  onTap: (() async {
                    await _getImageFromGallery(context);
                    //return _image;
                  }),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: Text("Camera"),
                  onTap: (() async {
                    await _getImageFromCamera(context);
                    //return _image;
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> _getImageFromGallery(BuildContext context) async {
    _pickedFile = await picker.getImage(source: ImageSource.gallery);
  }

  static Future<void> _getImageFromCamera(BuildContext context) async {
    _pickedFile = await picker.getImage(source: ImageSource.camera);
  }
}
