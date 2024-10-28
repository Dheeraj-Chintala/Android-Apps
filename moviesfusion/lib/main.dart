import 'package:flutter/material.dart';
import 'homepage.dart';
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),

      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: const Color.fromARGB(255, 32, 31, 31),
        ),
        
      ),
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
    return Homepage();
  }
}