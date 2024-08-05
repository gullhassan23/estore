import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CommonFunctions {
  pickImage(ImageSource source) async {
    ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (_file != null) {
      return await _file.readAsBytes();
    }
    print("No Image is selected");
  }

  String getUid() {
    return (100000 + Random().nextInt(10000)).toString();
  }

  void displaYSnacKBaR(String message, BuildContext context) {
    var snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

Future<List<Uint8List>> pickproducts() async {
  final ImagePicker _picker = ImagePicker();
  List<Uint8List> imagesData = [];

  // Pick multiple images
  final List<XFile>? images = await _picker.pickMultiImage();

  if (images != null && images.isNotEmpty) {
    for (var image in images) {
      Uint8List imageData = await image.readAsBytes();
      imagesData.add(imageData);
    }
  }

  return imagesData;
}
