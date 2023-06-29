import 'package:firebase_auth/firebase_auth.dart';

import '../core/components/widgets/smart_dialog.dart';

class FirebaseAuthService {
  static final _firebaseAuth = FirebaseAuth.instance;

  static Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  //check if user is login
  static bool isUserLogin() {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  static Future<User?> signIn(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      CustomDialog.dismiss();
      if (e.code == 'user-not-found') {
        CustomDialog.showError(
            title: 'Authentication failed',
            message: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        CustomDialog.showError(
            title: 'Authentication failed',
            message: 'Wrong password provided for that user.');
      } else {
        CustomDialog.showError(
            title: 'Authentication failed', message: e.message!);
      }
    }
    return null;
  }

  static Future<String> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  static User getCurrentUser() {
    return _firebaseAuth.currentUser!;
  }

  // create user with email and password
  static Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      CustomDialog.dismiss();
      CustomDialog.showError(
          title: 'Authentication failed', message: e.message!);
    }
    return null;
  }

  static sendEmailVerification() {
    final currentUser = _firebaseAuth.currentUser;
    currentUser!.sendEmailVerification();
  }
}
