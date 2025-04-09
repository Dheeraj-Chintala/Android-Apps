import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Upcomingevents extends StatefulWidget {
  const Upcomingevents({super.key});

  @override
  State<Upcomingevents> createState() => _UpcomingeventsState();
}

class _UpcomingeventsState extends State<Upcomingevents> {
  var eventdata =[

    
  ];
  getdata() async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase.from('events').select();

      setState(() {
        eventdata = response;
      });
    } catch (e) {
      print(e);
    }
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
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: eventdata.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      color: const Color.fromARGB(255, 184, 180, 180),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              height: 300,
                              width: double.infinity,
                              child: Image.network(
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.broken_image,
                                    size: 150,
                                  );
                                },
                                eventdata[index]['imagelink'],
                                fit: BoxFit.cover,
                              )),
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                eventdata[index]['eventname'],
                                style: GoogleFonts.aBeeZee(fontSize: 25),
                              )),
                          Text("Venue: ${eventdata[index]['venue']}"),
                          Text("Date: ${eventdata[index]['date']}"),
                          Text("Timings: ${eventdata[index]['timings']}"),
                        ],
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
