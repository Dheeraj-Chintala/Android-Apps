import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        //  mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(height: 30),
          Image.asset('assets/applogo.png', height: 200),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Fitness Tracking App',
              style: GoogleFonts.bebasNeue(
                fontSize: 30,
                color: Color.fromARGB(255, 38, 255, 0),
              ),
            ),
          ),
          Container(height: 30),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Created By A2 Team',
                  style: GoogleFonts.ptSansNarrow(
                    fontSize: 17,
                    color: Color.fromARGB(255, 175, 175, 175),
                  ),
                ),
                Text(
                  'For App Development-ⅠⅠ',
                  style: GoogleFonts.ptSans(
                    fontSize: 25,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                SizedBox(
                  // width: 40,
                  height: 30,),
                Text(
                  'Team Members',
                  style: GoogleFonts.ptSansNarrow(
                    fontSize: 17,
                    color:Color.fromARGB(255, 175, 175, 175),
                  ),
                ),
                Text(
                  'Maneela Andrasu\nDheeraj Chintala\nRohith Burgula\nAbhinav Akkireddy',
                  style: GoogleFonts.ptSans(
                    fontSize: 20,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}
