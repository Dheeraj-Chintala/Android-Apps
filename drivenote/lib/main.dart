import 'package:drivenote/screens/home.dart';
import 'package:drivenote/screens/login.dart';
import 'package:drivenote/screens/note.dart';
import 'package:drivenote/stateManagement.dart';
import 'package:drivenote/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  GoogleSignInAccount? currentUser;
  bool isChecking = true;

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  Future<void> checkUser() async {
    GoogleSignIn googleSignIn = GoogleSignIn();

    googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        currentUser = account;
      });
    });

    GoogleSignInAccount? account = await googleSignIn.signInSilently();
    setState(() {
      currentUser = account;
      isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userTheme = ref.watch(themeNotifierProvider);

    if (isChecking) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: userTheme,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    final GoRouter routes = GoRouter(
      initialLocation: currentUser == null ? "/login" : "/home",
      routes: [
        GoRoute(path: "/login", builder: (context, state) => const login()),
        GoRoute(path: "/home", builder: (context, state) => const Home()),
        GoRoute(path: "/note", builder: (context, state) => const Note()),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: userTheme,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,

      routerConfig: routes,
    );
  }
}
