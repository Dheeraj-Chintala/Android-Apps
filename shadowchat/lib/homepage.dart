import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadowchat/account.dart';
import 'package:shadowchat/chat.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with WidgetsBindingObserver {
  final supabase = Supabase.instance.client;
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setonlinestatus(true);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      setonlinestatus(false); 
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setonlinestatus(true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    setonlinestatus(false);
    super.dispose();
  }

  List<Widget> pages = [home(), Account()];
  changenav(int index) {
    setState(() {
      currentindex = index;
    });
  }

  int currentindex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color.fromARGB(255, 213, 229, 255)
          : const Color.fromARGB(255, 45, 45, 45),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFA8C8FF)
            : const Color.fromARGB(255, 34, 34, 34),
        titleSpacing: 0,
        title: Image.asset(
          "assets/logowithname.png",
          height: 45,
        ),
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => <PopupMenuEntry>[
                    PopupMenuItem(child: Text("Privacy Policy")),
                  ])
        ],
      ),
      body: pages[currentindex],
      bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          currentIndex: currentindex,
          selectedItemColor: Theme.of(context).brightness == Brightness.light
              ? const Color.fromARGB(255, 0, 0, 0)
              : const Color.fromARGB(255, 255, 255, 255),
          unselectedItemColor: const Color.fromARGB(255, 76, 76, 76),
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? const Color(0xFFA8C8FF)
              : const Color.fromARGB(255, 34, 34, 34),
          onTap: changenav,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded), label: "home"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "account"),
          ]),
    );
  }
}

class home extends StatelessWidget {
  home({
    super.key,
  });

  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
   final user = supabase.auth.currentUser;
  final usermail = user?.email;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              "Chats",
              style: GoogleFonts.ptSans(),
            ),
          ),
          StreamBuilder(
            
              stream: supabase
                  .from('users')
                  .stream(primaryKey: ['id'])
                  .neq('email', usermail!)
                  .order('lastseen', ascending: true),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final users = snapshot.data!;
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: users.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Chat(
                                        snapshot: users[index],
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: ListTile(
                            leading: Badge(
                              isLabelVisible: users[index]['online'],
                              label: Text(" "),
                              backgroundColor: Colors.green,
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? const Color.fromARGB(255, 172, 204, 255)
                                    : const Color.fromARGB(255, 76, 76, 76),
                                radius: 25,
                                child: Text(
                                  users[index]['username'][0],
                                  style: GoogleFonts.ptSans(fontSize: 25),
                                ),
                              ),
                            ),
                            title: Text(
                              users[index]['username'],
                              style: GoogleFonts.ptSans(fontSize: 18),
                            ),
                          ),
                        ),
                      );
                    });
              }),
        ],
      ),
    );
  }
}
