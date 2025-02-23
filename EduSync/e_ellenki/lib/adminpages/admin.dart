import 'package:e_ellenki/adminpages/aadminhomepage.dart';
import 'package:e_ellenki/adminpages/adminnotification.dart';
import 'package:e_ellenki/adminpages/adminsettings.dart';
import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  int selectedindex = 0;
  bottomnavchange(int index) {
    setState(() {
      selectedindex = index;
    });
  }

  List<Widget> pages = [
    AdminHomepage(),
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
