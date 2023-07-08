import 'package:uuid/uuid.dart';

class Utils {
  static String generateUuid() {
    return const Uuid().v4();
  }
}
