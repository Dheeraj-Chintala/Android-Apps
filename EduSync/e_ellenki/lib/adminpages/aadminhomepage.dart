import 'package:e_ellenki/adminpages/attendance.dart';
import 'package:e_ellenki/adminpages/discussionpage.dart';
import 'package:e_ellenki/adminpages/eventspage.dart';
import 'package:e_ellenki/adminpages/librarypage.dart';
import 'package:e_ellenki/adminpages/schedulepage.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminHomepage extends StatefulWidget {
  const AdminHomepage({super.key});

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  List feauturelist = [
    "attendance.png",
    "library.png",
    "events.png",
    "examsched.png",
    "discussion.png"
  ];
  List<Widget> featurepages = [
    Attendancepage(),
    Librarypage(),
    Eventspage(),
    Examschedule(),
    Discussionpage()
  ];
  getdata() async {
    final email = Supabase.instance.client.auth.currentUser?.email;
    final nameresponse = await Supabase.instance.client
        .from('users')
        .select('name')
        .eq('email', email!)
        .single();
    final deptresponse = await Supabase.instance.client
        .from('users')
        .select('dept')
        .eq('email', email)
        .single();
    setState(() {
      profname = nameresponse['name'];
      profdept=deptresponse['dept'];
    });
  }

  var profname = "";
  var profdept="";
  @override
  void initState() {
    // TODO: implement initState
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
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/avatar.png"),
                  radius: 30,
                ),
                Column(
                  children: [Text("Prof $profname"), Text("Dept of $profdept")],
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 237, 237, 237),
                    backgroundImage: AssetImage("assets/nobacklogo.png",),
                    radius: 25,
                  ),
                ),
              ],
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
            ),
          ],
        ),
      ),
    );
  }
}
