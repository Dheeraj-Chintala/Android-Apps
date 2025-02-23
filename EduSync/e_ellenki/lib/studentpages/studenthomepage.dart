import 'package:e_ellenki/studentpages/studentattendance.dart';
import 'package:e_ellenki/studentpages/studentevent.dart';
import 'package:e_ellenki/studentpages/studentlibrary.dart';
import 'package:e_ellenki/studentpages/studentresult.dart';
import 'package:e_ellenki/studentpages/studentsched.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentHomepage extends StatefulWidget {
  const StudentHomepage({super.key});

  @override
  State<StudentHomepage> createState() => _StudentHomepageState();
}

class _StudentHomepageState extends State<StudentHomepage> {
  final supabase = Supabase.instance.client;
  var username = "";
  var userclass = "";
  List feauturelist = [
    "attendance.png",
    "library.png",
    "events.png",
    "examsched.png",
    "result.png"
  ];
  List<Widget> featurepages = [
    Studentattendance(),
    Studentlibrary(),
    Studentevent(),
    Studentsched(),
    Studentresult(),
  ];
  var presentcount = 0;

  getdata() async {
    dynamic pcount = 0;
    final email = await supabase.auth.currentUser!.email;
    final response = await supabase
        .from('users')
        .select('name, class_subject')
        .eq('email', email!)
        .single();
    setState(() {
      username = response['name'];
      userclass = response['class_subject'];
    });
    final attendanceresponse = await supabase
        .from('students')
        .select('attendance')
        .eq('name', username)
        .maybeSingle();
    Map<String, dynamic> existingdata = attendanceresponse?['attendance'];
    existingdata.forEach((date, sub) {
      pcount += sub.values.where((stat) => stat == 'Present').length;
    });
    setState(() {
      presentcount = pcount;
    });
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/avatar.png"),
                      radius: 30,
                    ),
                  ),
                  Column(
                    children: [Text(username), Text(userclass)],
                  ),
                  Spacer(),
                   CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 237, 237, 237),
                backgroundImage: AssetImage("assets/nobacklogo.png"),
                radius: 25,
              ),
              SizedBox(
                height: 20,
                width: 20,
              ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 150,
                  color: Colors.amber[100],
                  child: Row(
                    children: [
                      Spacer(),
                      Text(
                        "Attendance \nPrecentage",
                        style: GoogleFonts.aBeeZee(fontSize: 25),
                      ),
                      Spacer(),
                      CircularPercentIndicator(
                          progressColor:
                              const Color.fromARGB(255, 31, 171, 112),
                          backgroundColor:
                              const Color.fromARGB(255, 254, 119, 71),
                          center: Text(
                              '${((presentcount / 30) * 100).toStringAsFixed(2)} %'),
                          animation: true,
                          percent: presentcount / 30,
                          lineWidth: 20,
                          startAngle: 180,
                          radius: 60),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                children: List.generate(feauturelist.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => featurepages[index]));
                          },
                          child: Image.asset("assets/${feauturelist[index]}")),
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
