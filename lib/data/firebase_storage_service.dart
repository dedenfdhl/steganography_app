import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseStorageService {
  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  static Future<void> uploadImage(File image, String ref) async {
    try {
      await _firebaseStorage.ref(ref).putFile(image);
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }
  }
}
