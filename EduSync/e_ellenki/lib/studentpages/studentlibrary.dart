import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Studentlibrary extends StatefulWidget {
  const Studentlibrary({super.key});

  @override
  State<Studentlibrary> createState() => _StudentlibraryState();
}

class _StudentlibraryState extends State<Studentlibrary> {
  List Books = [];
  getdata() async {
    final supabase = Supabase.instance.client;
    try {
      final email = supabase.auth.currentUser!.email;
      final response =
          await supabase.from('library_books').select().eq('email', email!);
      setState(() {
        Books = response;
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
                  color: const Color.fromARGB(255, 143, 152, 253),
                  child: Row(
                    children: [Spacer(), Image.asset("assets/library.png")],
                  ),
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: Text("Books Taken"),
                )),
            ListView.builder(
                shrinkWrap: true,
                itemCount: Books.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      tileColor: const Color.fromARGB(255, 163, 171, 251),
                      leading: CircleAvatar(),
                      title: Text(
                        Books[index]['book_name'],
                        style: GoogleFonts.aBeeZee(fontSize: 20),
                      ),
                      subtitle: Text(
                        "Author: ${Books[index]['author']}\nDate:${Books[index]['date']}  \tLast Date:${Books[index]['last_date']} ",
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
