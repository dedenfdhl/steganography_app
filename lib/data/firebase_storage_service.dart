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

  static Future<String> downloadUrl(String ref) async {
    String downloadUrl = await _firebaseStorage.ref(ref).getDownloadURL();

    return downloadUrl;
  }

  static Future<bool> downloadAndSaveMatFile(String filePathRef) async {
    // String filePath = 'hasil-embedding/${userId}_terwatermark/data.mat';
    String filePath = filePathRef;

    try {
      // Referensi ke file di Firebase Storage
      Reference ref = _firebaseStorage.ref().child(filePath);

      final metadata = await ref.getMetadata();

      String filename = metadata.name;

      File file = File('/storage/emulated/0/Download/$filename');
      await ref.writeToFile(file);

      // String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      // String newFileName = 'data_$timestamp.mat';
      // File renamedFile =
      //     await file.rename('/storage/emulated/0/Download/$newFileName');

      return true;
    } catch (e) {
      print(e);

      return false;
    }
  }

  // static Future downloadFile(String ref) async {
  //   String temp = await _firebaseStorage.ref(ref).getDownloadURL();
  //   print(temp);
  //   if (!await launchUrl(Uri.parse(temp))) {
  //     print('gagal');
  //     throw Exception('Could not launch $temp');
  //   }
  //   Reference storageRef = _firebaseStorage.ref(ref);

  //   final dir = await getApplicationDocumentsDirectory();
  //   final path = '${dir.path}/FileMat/mat_aku.mat';
  //   final file = await File(path).create(recursive: true);
  //   print(file.path);

  //   final downloadTask = storageRef.writeToFile(file);

  //   downloadTask.snapshotEvents.listen((taskSnapshot) {
  //     switch (taskSnapshot.state) {
  //       case TaskState.running:
  //         log('running ');
  //         break;
  //       case TaskState.paused:
  //         log('paused');
  //         break;
  //       case TaskState.success:
  //         log('success');
  //         break;
  //       case TaskState.canceled:
  //         log('canceled');
  //         break;
  //       case TaskState.error:
  //         log('error');
  //         break;
  //     }
  //   });

  //   // String downloadUrl = await _firebaseStorage.ref(ref).getDownloadURL();

  //   // return downloadUrl;
  // }
}
