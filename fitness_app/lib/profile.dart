import 'package:fitness_app/authenticate.dart';
import 'package:fitness_app/calendar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Profile extends StatefulWidget {
  Profile({super.key});

  late final bcalories;
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final supabase = Supabase.instance.client;
  Map<String, dynamic> data = {};
  getdata() async {
    try {
      final mail = supabase.auth.currentUser!.email!;
      final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final response = await supabase
          .from('progress')
          .select()
          .eq('email', mail)
          .eq('date', date);
      setState(() {
        data = response.single;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  logoutDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 55, 55, 55),
          title: Text("Logout"),
          content: Text("Are you sure You want to Logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("cancel"),
            ),
            ElevatedButton(
              
              onPressed: () {
                Navigator.pop(context);
                Authserve().logout();
              },
              child: Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => logoutDialog(),
            icon: Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: CircularPercentIndicator(
                backgroundColor: const Color.fromARGB(255, 32, 31, 31),
                animation: true,
                progressColor: const Color.fromARGB(255, 7, 255, 23),
                radius: 100,
                percent: (data['caloriespent'] ?? 1).toInt() / 1500,
                startAngle: 180,
                animationDuration: 1000,
                lineWidth: 15,
                circularStrokeCap: CircularStrokeCap.round,
                center: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '    ${(data['caloriespent'] ?? 0).toInt()}',

                        style: GoogleFonts.bebasNeue(fontSize: 30),
                      ),
                      TextSpan(text: "/1500 cal"),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            //fourth row
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: const Color.fromARGB(255, 39, 39, 39),
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Equivalent to\n',
                                    style: GoogleFonts.ptSansNarrow(
                                      fontSize: 15,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '${((data['caloriespent'] ?? 0) * 11).toInt()} steps\n',

                                    style: GoogleFonts.bebasNeue(
                                      fontSize: 30,
                                      color: const Color.fromARGB(
                                        255,
                                        38,
                                        255,
                                        0,
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Approx',
                                    style: GoogleFonts.ptSansNarrow(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 100,
                          color: const Color.fromARGB(255, 39, 39, 39),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Spent\n',
                                    style: GoogleFonts.ptSansNarrow(
                                      fontSize: 15,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ' ${(data['exercisesdone'] ?? 0) * 5} Minutes\n',
                                    style: GoogleFonts.bebasNeue(
                                      fontSize: 30,
                                      color: const Color.fromARGB(
                                        255,
                                        38,
                                        255,
                                        0,
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'of Time',
                                    style: GoogleFonts.ptSansNarrow(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 200,
                          color: const Color.fromARGB(255, 39, 39, 39),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Ensure\n',
                                    style: GoogleFonts.ptSansNarrow(
                                      fontSize: 15,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '8 hrs\n',
                                    style: GoogleFonts.bebasNeue(fontSize: 30),
                                  ),
                                  TextSpan(
                                    text: 'of Sleep',
                                    style: GoogleFonts.ptSansNarrow(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 200,
                          color: const Color.fromARGB(255, 39, 39, 39),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Drink\n',
                                    style: GoogleFonts.ptSansNarrow(
                                      fontSize: 15,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '3.7 lit\n',
                                    style: GoogleFonts.bebasNeue(fontSize: 30),
                                  ),
                                  TextSpan(
                                    text: ' of Water',
                                    style: GoogleFonts.ptSansNarrow(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 200,
                          color: const Color.fromARGB(255, 39, 39, 39),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Today\n',
                                    style: GoogleFonts.ptSansNarrow(
                                      fontSize: 15,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${data['exercisesdone'] ?? 0}\n',
                                    style: GoogleFonts.bebasNeue(fontSize: 30),
                                  ),
                                  TextSpan(
                                    text: 'Exercises Done',
                                    style: GoogleFonts.ptSansNarrow(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 70,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 39, 39, 39),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Calendar()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_month_rounded, size: 30),
                      Text(
                        "Progress",
                        style: GoogleFonts.bebasNeue(fontSize: 25),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
