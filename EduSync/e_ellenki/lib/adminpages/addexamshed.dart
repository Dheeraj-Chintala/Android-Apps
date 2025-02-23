import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Addexamshed extends StatefulWidget {
  const Addexamshed({super.key});

  @override
  State<Addexamshed> createState() => _AddexamshedState();
}

class _AddexamshedState extends State<Addexamshed> {
  var subject = TextEditingController();
  var date = TextEditingController();
  var timings = TextEditingController();
  uploadData(subject, date, timings) async {
    final supabase = Supabase.instance.client;
    try {
      await supabase
          .from('exam_schedules')
          .insert({'subject': subject, 'date': date, 'timings': timings});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
                alignment: Alignment.center,
                child: Text("Exam Details",
                    style: GoogleFonts.roboto(
                        fontSize: 30,
                        color: const Color.fromARGB(255, 19, 45, 145)))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: subject,
                decoration: InputDecoration(
                    labelText: "Subject",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: date,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                      initialDate: DateTime.now(),
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2026));
                  setState(() {
                    date.text = picked.toString().split(" ").first;
                  });
                },
                decoration: InputDecoration(
                    labelText: "Date",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: timings,
                decoration: InputDecoration(
                    labelText: "Timings",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
            ),
            Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll<Color>(
                              const Color.fromARGB(255, 254, 119, 71))),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Center(child: CircularProgressIndicator());
                            });

                        await uploadData(subject.text, date.text, timings.text);
                        subject.clear();
                        date.clear();
                        timings.clear();

                        Navigator.pop(context);
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      )),
                ))
          ],
        ),
      ),
    );
  }
}
