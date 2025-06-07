import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gdg_solution/app_theme.dart';
import 'package:gdg_solution/rootpage.dart';
import 'package:gdg_solution/userpages/stateMgmt.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((_) {
    debugPrint("Firebase Initialized");
  });

  runApp(ChangeNotifierProvider(
    create: (context) => UserData(),
    child: Myapp(),
  ));
}

class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserData>(
      builder: (context, provider, child) {
        return MaterialApp(
          themeMode: provider.userTheme,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          debugShowCheckedModeBanner: false,
          home: const Rootpage(),
        );
      },
    );
  }
}
