import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminNotifications extends StatefulWidget {
  const AdminNotifications({super.key});

  @override
  State<AdminNotifications> createState() => _AdminNotificationsState();
}

class _AdminNotificationsState extends State<AdminNotifications> {
  var notifiaction = [];
  getdata() async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase.from('notifications').select();
      setState(() {
        notifiaction = response;
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
        title: Text("Notifications"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: const Color.fromARGB(255, 254, 119, 71),
              size: 30,
            )),
        toolbarHeight: 70,
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
            SizedBox(
              height: 20,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: notifiaction.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      tileColor: const Color.fromARGB(255, 163, 171, 251),
                      leading: CircleAvatar(),
                      title: Text(notifiaction[index]['message'],
                          style: GoogleFonts.aBeeZee(fontSize: 20)),
                      subtitle: Text(notifiaction[index]['sender']),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
