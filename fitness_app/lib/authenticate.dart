import 'package:supabase_flutter/supabase_flutter.dart';

import 'homepage.dart';
import 'package:flutter/material.dart';

class Authserve {
  final supabase = Supabase.instance.client;

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);
      if (context.mounted) {
        Navigator.pop(context);
      }

      await Future.delayed(Duration(seconds: 1));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
      print(e.toString());
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    try {
      await supabase.auth.signUp(email: email, password: password);
      final username = email.split('@').first;
      addUserToDatabase(username, email);
      if (context.mounted) {
        Navigator.pop(context);
      }
      await Future.delayed(Duration(seconds: 1));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
      print(e.toString());
    }
  }

  logout() async {
    
    await supabase.auth.signOut();
  }

  void addUserToDatabase(String name, String email) async {
    try {
      await Supabase.instance.client.from('users').insert({
        'username': name[0].toUpperCase() + name.substring(1),
        'email': email,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
