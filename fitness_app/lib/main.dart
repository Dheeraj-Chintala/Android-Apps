import 'package:fitness_app/homepage.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: 'SUPABASE_URL',
      anonKey:
          'SUPABASE_ANON_KEY');
  runApp(MaterialApp(
    home: const MyApp(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        colorScheme: const ColorScheme.dark(
      primary: Color.fromARGB(240, 38, 255, 0),
    )),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: Supabase.instance.client.auth.onAuthStateChange,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final session = snapshot.hasData ? snapshot.data!.session : null;
            if (session != null) {
            return Homepage();
            }
            return Loginpage();
            
          }
          ),
    );
  }
}
