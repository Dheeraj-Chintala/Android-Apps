import 'package:e_ellenki/adminpages/admin.dart';

import 'package:e_ellenki/pages/getstarted.dart';
import 'package:e_ellenki/providerpage.dart';
import 'package:e_ellenki/studentpages/student.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: "https://uevuvfwuteanrmltyxcy.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVldnV2Znd1dGVhbnJtbHR5eGN5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg3NjA4NTcsImV4cCI6MjA1NDMzNjg1N30.EVsMPfY-4rAnUhV1unVuMez1Z0drS7EfjrzlGFoigcE",
  );

  runApp(ChangeNotifierProvider(
    create: (context) => Providerpage(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<String?> getusertype(String? email) async {
    if (email == null) return null;

    final response = await Supabase.instance.client
        .from('users')
        .select('type')
        .eq('email', email)
        .single();

    return response['type'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final session = snapshot.hasData ? snapshot.data!.session : null;
          if (session == null) {
            return Getstarted();
          }

          return FutureBuilder<String?>(
            future: getusertype(session.user.email),
            builder: (context, typeSnapshot) {
              if (typeSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final type = typeSnapshot.data;
              if (type == 'faculty') {
                return Admin();
              } else if (type == 'student') {
                return Student();
              } else {
                return Getstarted();
              }
            },
          );
        },
      ),
    );
  }
}
