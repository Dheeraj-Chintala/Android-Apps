import 'package:e_ellenki/adminpages/adminnotification.dart';
import 'package:e_ellenki/adminpages/adminsettings.dart';
import 'package:e_ellenki/studentpages/studenthomepage.dart';
import 'package:flutter/material.dart';

class Student extends StatefulWidget {
  const Student({super.key});

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  int selectedindex = 0;
  bottomnavchange(int index) {
    setState(() {
      selectedindex = index;
    });
  }

  List<Widget> pages = [
    StudentHomepage(),
    AdminNotifications(),
    AdminSettings(),
  ];
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      body: pages[selectedindex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 139, 113, 211),
          selectedItemColor: const Color.fromARGB(255, 19, 45, 145),
          showUnselectedLabels: false,
          currentIndex: selectedindex,
          onTap: bottomnavchange,
          items: [
            BottomNavigationBarItem(icon:Icon(Icons.home_rounded),label: 'Home'),
             BottomNavigationBarItem(icon:Icon(Icons.notifications),label: 'Notifications'),
              BottomNavigationBarItem(icon:Icon(Icons.settings),label: 'Settings'),

      
          ]),
    );
  }
}