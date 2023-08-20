import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignIn? _googleSignIn;

  static Future<User?> login(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    final user = userCredential.user;

    return user;
  }

  static Future<User?> register(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final user = userCredential.user;

    return user;
  }

  static Future<void> logOut() async {
    await _auth.signOut();
    if (_googleSignIn != null) {
      await _googleSignIn!.disconnect();
      _googleSignIn = null;
    }
  }

  static Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  static Future<UserCredential?> signInWithGoogle() async {
    try {
      _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? gUser = await _googleSignIn!.signIn();

      final GoogleSignInAuthentication? gAuth = await gUser?.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: gAuth?.accessToken, idToken: gAuth?.idToken);

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Stream<User?> get userStream => _auth.authStateChanges();

  static User? get currentUser => _auth.currentUser;
}
