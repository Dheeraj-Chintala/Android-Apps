import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Studentevent extends StatefulWidget {
  const Studentevent({super.key});

  @override
  State<Studentevent> createState() => _StudenteventState();
}

class _StudenteventState extends State<Studentevent> {
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
        ],      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 150,
                  color: const Color.fromARGB(255, 19, 45, 145),
                  child: Row(
                    children: [Spacer(), Image.asset("assets/events.png")],
                  ),
                ),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: eventdata.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
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
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
