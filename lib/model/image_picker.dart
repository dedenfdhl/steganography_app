import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';


class ImagePickerHandler {
  final ImagePicker imagePicker = ImagePicker();
  XFile? pickedimage;

  Future<File?> pickImage () async {
    try {
      pickedimage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedimage != null) {
      return File(pickedimage!.path);
    }
      return null; 
    } catch(e) {
      debugPrint(e.toString());
      return null;
    }
  }
}