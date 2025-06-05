import 'package:fitness_app/about.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home.dart';
import 'profile.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = Supabase.instance.client.auth.currentUser;

  int selectedindex = 0;

  List<Widget> pages = [Home(), Profile(), About()];

  bottomnavchange(int index) {
    setState(() {
      selectedindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: pages[selectedindex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 38, 255, 0),
        showUnselectedLabels: false,
        currentIndex: selectedindex,
        onTap: bottomnavchange,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded),label: 'Home',),
          BottomNavigationBarItem(icon: Icon(Icons.stacked_bar_chart_rounded),label: 'Stats',),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'About'),
        ],
      ),
    );
  }
}
