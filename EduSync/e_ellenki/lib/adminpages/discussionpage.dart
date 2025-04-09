import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Discussionpage extends StatefulWidget {
  const Discussionpage({super.key});

  @override
  State<Discussionpage> createState() => _DiscussionpageState();
}

class _DiscussionpageState extends State<Discussionpage> {
  var discussion = [];
  getdata() async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase.from('discussions').select();
      setState(() {
        discussion = response;
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
                    children: [Spacer(), Image.asset("assets/discussion.png")],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: discussion.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      tileColor: const Color.fromARGB(255, 255, 174, 144),
                      leading: CircleAvatar(),
                      title: Text(discussion[index]['title'],
                          style: GoogleFonts.aBeeZee(fontSize: 18)),
                      subtitle: Text(discussion[index]['uploader']),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
