// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:gdg_solution/splashScreen.dart';
// import 'package:gdg_solution/userpages/homepage.dart';

// class Authgate {
//   Future signOut(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => Splashscreen()));
//   }

//   Future loginWithEmail(
//       String email, String password, BuildContext context) async {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         });
//     try {
//       await FirebaseAuth.instance
//           .signInWithEmailAndPassword(email: email, password: password);
//       Navigator.pop(context);
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => Homepage()));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           action: SnackBarAction(
//             label: "OK",
//             onPressed: () {},
//           ),
//           content: Text(e.toString())));
//       print(e);
//       return;
//     }
//   }

//   Future signUpWithEmail(
//       String email, String password, BuildContext context) async {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         });
//     try {
//       await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);

//       //data write
//       final user = await FirebaseAuth.instance.currentUser!.email!;
//       await FirebaseFirestore.instance.collection('users').doc(user).set({
//         'email': user,
//       });

//       Navigator.pop(context);

//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => Homepage()));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           action: SnackBarAction(
//             label: "OK",
//             onPressed: () {},
//           ),
//           content: Text(e.toString())));
//       print(e);

//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdg_solution/splashScreen.dart';
import 'package:gdg_solution/userpages/homepage.dart';

class Authgate {
  /// Helper method to show SnackBar
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {},
        ),
        content: Text(message),
      ),
    );
  }

  /// Sign Out Function
  Future signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    // Clear stack and go to Splashscreen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Splashscreen()),
      (route) => false,
    );
  }

  /// Login Function
  Future loginWithEmail(
      String email, String password, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);

      if (context.mounted) Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    } catch (e) {
      if (context.mounted) Navigator.pop(context);

      if (e is FirebaseAuthException) {
        _showErrorSnackBar(context, e.message ?? "Login failed");
      } else {
        _showErrorSnackBar(context, "Something went wrong");
      }

      print("Login Error: $e");
      return;
    }
  }

  /// Signup Function
  Future signUpWithEmail(
      String email, String password, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid) // use UID instead of raw email
            .set({
          'email': user.email,
        });
      }

      if (context.mounted) Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    } catch (e) {
      if (context.mounted) Navigator.pop(context);

      if (e is FirebaseAuthException) {
        _showErrorSnackBar(context, e.message ?? "Signup failed");
      } else {
        _showErrorSnackBar(context, "Something went wrong");
      }

      print("Signup Error: $e");
    }
  }
}

