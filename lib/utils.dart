import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Utils{
  Future<XFile?> getImage(ImageSource source) async {
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    return pickedFile;
  }

  Future <XFile?> getImageFromSource(BuildContext context) async {
    return await showDialog<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Source"),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  getImage(ImageSource.gallery).then((value) =>
                      Navigator.of(context).pop(value));
                },
                child: const Text("Gallery")),
            ElevatedButton(
                onPressed: () {
                  getImage(ImageSource.camera).then((value) =>
                  Navigator.of(context).pop(value));
                },
                child: const Text("Camera")),

          ]
        );
      },
    );

  }
}

