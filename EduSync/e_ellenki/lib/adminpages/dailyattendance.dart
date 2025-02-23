import 'package:e_ellenki/providerpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Dailyattendance extends StatefulWidget {
  Dailyattendance({super.key});

  @override
  State<Dailyattendance> createState() => _DailyattendanceState();
}

class _DailyattendanceState extends State<Dailyattendance> {
  final supabase = Supabase.instance.client;
  List<String> classes = [];
  String? drpclass;
  List<bool> attendance = [];
  List<String> studentname = [];
  final String date = DateTime.now().toIso8601String().split('T').first;
  int attendancecount = 0;
  var subject = "";
  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future<void> getdata() async {
    final responseclasses = await supabase.from('classes').select('classname');
    final no_classes = responseclasses
        .map<String>((row) => row['classname'] as String)
        .toList();

    if (mounted) {
      setState(() {
        classes = no_classes;
        drpclass = no_classes.isNotEmpty ? no_classes.first : null;
      });

      if (drpclass != null) {
        dropclassdata(drpclass!);
      }
    }
  }

  Future<void> dropclassdata(String selectedClass) async {
    final responsestudents = await supabase
        .from('users')
        .select('name')
        .eq('type', 'student')
        .eq('class_subject', selectedClass);

    final no_students =
        responsestudents.map((row) => row['name'] as String).toList();

    if (mounted) {
      setState(() {
        studentname = no_students;
        attendance = List.filled(studentname.length, false);
        attendancecount = 0;
      });
    }
  }

  Future<void> addSubjectToDate(
      String date, String subject, String status, String stdname) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase
          .from('students')
          .select('attendance')
          .eq('name', stdname)
          .maybeSingle();

      Map<String, dynamic> existingData = response?['attendance'] ?? {};

      if (!existingData.containsKey(date)) {
        existingData[date] = {};
      }

      existingData[date][subject] = status;

      await supabase
          .from('students')
          .update({'attendance': existingData}).eq('name', stdname);

      print('Subject added/updated successfully.');
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerclass = Provider.of<Providerpage>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: classes.isEmpty
                    ? CircularProgressIndicator()
                    : DropdownButton<String>(
                        borderRadius: BorderRadius.circular(10),
                        value: drpclass,
                        icon: Icon(Icons.keyboard_arrow_down),
                        items: classes.map((String item) {
                          return DropdownMenuItem(
                              value: item, child: Text(item));
                        }).toList(),
                        onChanged: (newClass) {
                          if (newClass != null) {
                            setState(() {
                              drpclass = newClass;
                            });
                            providerclass.updateclass(
                                dailypresent: attendancecount,
                                dailycount: attendance.length);
                            dropclassdata(newClass);
                          }
                        },
                      ),
              ),
            ),
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text("Students list",
                      style: GoogleFonts.ptSansNarrow(
                        fontSize: 20,
                      )),
                )),
            Container(
              child: studentname.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: studentname.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(studentname[index]),
                          trailing: Switch(
                            value: attendance[index],
                            onChanged: (value) async {
                              setState(() {
                                attendance[index] = value;
                                attendancecount += value ? 1 : -1;
                              });
                              final mail = Supabase
                                  .instance.client.auth.currentUser!.email;
                              final subjectname = await Supabase.instance.client
                                  .from('users')
                                  .select('class_subject')
                                  .eq('email', mail!)
                                  .single();
                              setState(() {
                                subject =
                                    subjectname['class_subject'] ?? "Not found";
                              });
                              if (attendance[index] == true) {
                                await addSubjectToDate(date, subject, "Present",
                                    studentname[index]);
                              } else {
                                await addSubjectToDate(date, subject, "Absent",
                                    studentname[index]);
                              }

                              providerclass.updateclass(
                                  dailypresent: attendancecount,
                                  dailycount: attendance.length);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
