import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthLobby {
  final supabase = Supabase.instance.client;

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> registerWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await supabase.auth.signUp(email: email, password: password);
      await Future.delayed(Duration(seconds: 2));

      final username = email.split('@').first;
      addUserToDatabase(username, email);
      Future.delayed(Duration(seconds: 2));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void addUserToDatabase(String name, String email) async {
    try {
      await Supabase.instance.client.from('users').insert({
        'username': name[0].toUpperCase() + name.substring(1),
        'online': false,
        'email': email,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
  }
}
