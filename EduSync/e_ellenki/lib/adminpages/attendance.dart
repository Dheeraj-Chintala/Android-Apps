import 'package:e_ellenki/adminpages/dailyattendance.dart';
import 'package:e_ellenki/adminpages/reportattendance.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Attendancepage extends StatefulWidget {
  const Attendancepage({super.key});

  @override
  State<Attendancepage> createState() => _AttendancepageState();
}

class _AttendancepageState extends State<Attendancepage> {
  getdata() async {
    final mail = Supabase.instance.client.auth.currentUser!.email;
    final subjectname = await Supabase.instance.client
        .from('users')
        .select('class_subject')
        .eq('email', mail!)
        .single();
    setState(() {
      subject = subjectname['class_subject'] ?? "Not found";
    });
  }

  var subject = "loading";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: const Color.fromARGB(255, 254, 119, 71),
                  size: 30,
                )),
            actions: [
              CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 237, 237, 237),
                backgroundImage: AssetImage("assets/nobacklogo.png"),
                radius: 20,
              ),
              SizedBox(
                height: 20,
                width: 20,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 150,
                      color: const Color.fromARGB(255, 254, 119, 71),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Subject:",
                                  style: GoogleFonts.aBeeZee(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Text(subject,
                                    style: GoogleFonts.aBeeZee(
                                        color: Colors.white, fontSize: 25)),
                              ],
                            ),
                          ),
                          Spacer(),
                          Expanded(child: Image.asset("assets/attendance.png"))
                        ],
                      ),
                    ),
                  ),
                ),
                TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    unselectedLabelColor: const Color.fromARGB(95, 0, 0, 0),
                    tabs: [
                      Tab(
                        text: "Daily",
                      ),
                      Tab(
                        text: "Report",
                      )
                    ]),
                SizedBox(
                  height: 900,
                  child: TabBarView(children: [
                    Dailyattendance(),
                    Reportattendance(),
                  ]),
                ),
              ],
            ),
          ),
        ));
  }
}
