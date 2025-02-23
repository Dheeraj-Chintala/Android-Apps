import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Authlobby {
  Future<void> loginmethod(
      {required String email,
      required String password,
      required BuildContext context}) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });
    try {
      await Supabase.instance.client.auth
          .signInWithPassword(email: email, password: password);
      Navigator.pop(context);

      await Future.delayed(Duration(seconds: 1));
      Navigator.pop(context);
    } catch (e) {
      print(e);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Enter valid Credentials")));
      Navigator.pop(context);
    }
  }
}
