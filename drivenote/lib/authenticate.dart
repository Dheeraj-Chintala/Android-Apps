import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authenticate {
  signInWithGoogle(BuildContext context) async {
    try {
      final user =
          await GoogleSignIn(
            scopes: ['https://www.googleapis.com/auth/drive.file', 'email'],
          ).signIn();
      final GoogleSignInAuthentication auth = await user!.authentication;

      final accessToken = auth.accessToken;
      debugPrint("Entered");
      if (user == null) return;
      context.go('/home');
      final securestorage = FlutterSecureStorage();
      await securestorage.write(key: "accesstoken", value: accessToken);
      debugPrint(user.displayName);
      debugPrint(user.id);
      debugPrint("second step");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  signOut(BuildContext context) async {
    try {
      await GoogleSignIn().signOut();

      await FlutterSecureStorage().deleteAll();
      context.go("/login");
    } catch (error) {
      print("Logout failed: $error");
    }
  }
}
