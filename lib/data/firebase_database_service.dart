
import 'package:firebase_database/firebase_database.dart';

class FirebaseDatabaseService {
  static final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  static final DatabaseReference _ref = _firebaseDatabase.ref();

  static void addData(String path, Object data) async {
    final ref = _ref.child(path);
    ref.set(data).asStream();
    // await ref.set(data);
  }

  static void updateData(String path, Map<String, dynamic> data) async {
    final Map<String, dynamic> updates = {};
    updates[path] = data;

    _ref.update(updates);
  }

  static Future<dynamic> getdata(String path) async {
    final snapshot = await _ref.child(path).get();

    if (snapshot.exists) return snapshot.value;

    return null;
  }
}
