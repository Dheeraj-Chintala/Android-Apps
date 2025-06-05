import 'package:fitness_app/chat.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'workout.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final usermail = Supabase.instance.client.auth.currentUser!.email;

  List categories = ['BEGINNER', 'INTERMEDIATE', 'ADVANCED'];

  List<dynamic> beginner = [];
  List<dynamic> intermediate = [];
  List<dynamic> advanced = [];
  List workout = [];
  dynamic data = ' ';
  List coverimages = [
    'assets/beginner.jpg',
    'assets/intermediate.jpg',
    'assets/advanced.jpg',
  ];
  Future<void> loadjson() async {
    final String response = await rootBundle.loadString('assets/csvjson.json');

    setState(() {
      data = json.decode(response);
      beginner =
          data.where((item) => item['Difficulty Level'] == 'Beginner').toList();
      intermediate =
          data
              .where((item) => item['Difficulty Level'] == 'Intermediate')
              .toList();
      advanced =
          data.where((item) => item['Difficulty Level'] == 'Advanced').toList();
      workout = [beginner, intermediate, advanced];
    });
  }

  @override
  void initState() {
    super.initState();
    loadjson();
  }
String getGreeting() {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return "Good morning\n";
  } else if (hour < 17) {
    return "Good afternoon\n";
  } else if (hour < 21) {
    return "Good evening\n";
  } else {
    return "Good night\n";
  }
}
  @override
  Widget build(BuildContext context) {
    final username = usermail!.split('@').first.toUpperCase();
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:getGreeting(),
                      style: GoogleFonts.bebasNeue(
                        color: const Color.fromARGB(255, 38, 255, 0),
                        fontSize: 40,
                      ),
                    ),
                    TextSpan(
                      text: username,
                      style: GoogleFonts.ptSansNarrow(
                        color: const Color.fromARGB(213, 255, 255, 255),
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text(
                "FOR YOU",
                style: GoogleFonts.ptSansNarrow(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
            Container(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => Workout(workoutdata: workout[index]),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      height: 140,
                      //  width:200,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(83, 78, 78, 79),
      
                        borderRadius: BorderRadius.circular(15),
                      ),
      
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
      
                        child: Stack(
                          children: [
                            Image.asset(
                              width: double.infinity,
                              coverimages[index],
                              fit: BoxFit.cover,
                            ),
                            Container(
                              height: 140,
                              color: const Color.fromARGB(107, 0, 0, 0),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                categories[index],
                                
                                style: GoogleFonts.bebasNeue(
      
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

         floatingActionButton: FloatingActionButton(
            tooltip: "ChatBot",
            onPressed:(){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Chat()));
            },
          child: Image.asset("assets/chat.png",height: 70,),
          ),
    );
  }
}
