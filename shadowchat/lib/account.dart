import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  TextEditingController textcontroller = TextEditingController();
  bool isvisble = true;
  handleVisible() {
    setState(() {
      isvisble = !isvisble;
    });
  }

  final supabase = Supabase.instance.client;
  String username = "loading..";
  fetchusername() async {
    try {
      var usermail = await supabase.auth.currentUser!.email!;

      final userRow =
          await supabase.from('users').select().eq('email', usermail).single();
      setState(() {
        username = userRow['username'];
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchusername();
  }

  setonlinestatus(bool status) async {
    try {
      final usermail = supabase.auth.currentUser!.email!;

      await supabase.from('users').update({
        'online': status,
      }).eq('email', usermail);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  supabaseSignout() async {
    setonlinestatus(false);
    await supabase.auth.signOut();
    debugPrint("signout");
  }

  uploadusername() async {
    try {
      var usermail = await supabase.auth.currentUser!.email!;
      await supabase.from('users').update(
          {'username': textcontroller.text.trim()}).eq('email', usermail);

      await supabase.from('messages').update(
          {'sender': textcontroller.text.trim()}).eq('sender', username);
      textcontroller.clear();
      Future.delayed(Duration(seconds: 1));
      fetchusername();
      handleVisible();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? const Color.fromARGB(255, 213, 229, 255)
            : const Color.fromARGB(255, 45, 45, 45),
        body: Center(
          child: AlertDialog(
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? const Color.fromARGB(255, 185, 212, 255)
                : const Color.fromARGB(255, 51, 51, 51),
            content: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Profile",
                        style: GoogleFonts.ptSansNarrow(
                            fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: handleVisible, icon: Icon(Icons.edit))
                    ],
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.light
                              ? const Color.fromARGB(255, 172, 204, 255)
                              : const Color.fromARGB(255, 69, 69, 69),
                      radius: 40,
                      child: Text(
                        username[0],
                        style: GoogleFonts.ptSans(fontSize: 40),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Name",
                    style: GoogleFonts.ptSansNarrow(fontSize: 20),
                  ),
                  isvisble
                      ? Text(username,
                          style: GoogleFonts.ptSansNarrow(fontSize: 30))
                      : TextField(
                          controller: textcontroller,
                          decoration: InputDecoration(
                              // label: Text("Enter New Name"),
                              border: UnderlineInputBorder()),
                        ),
                  Divider(),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: isvisble ? supabaseSignout : uploadusername,
                        child: isvisble ? Text("Log Out") : Text("Done")),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
