import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminSettings extends StatefulWidget {
  const AdminSettings({super.key});

  @override
  State<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  List settlist = [
    "Profile",
    "Notifications",
    "Settings & Privacy",
    "Support & Feedback",
    "FAQs",
  ];

  List methods = [
    () {},
    () {},
    () {},
    () {},
    () {},
  ];
  void logoutAndRestart(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_back,
                  color: const Color.fromARGB(255, 254, 119, 71),
                  size: 30,
                )),
          ],
        ),
        title: Text("Settings"),
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
      body: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: settlist.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: methods[index],
                      child: ListTile(
                        title: Text(
                          settlist[index],
                          style: TextStyle(fontSize: 20),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                    Divider(
                      height: 0,
                    )
                  ],
                );
              }),
          GestureDetector(
            onTap: () {
              logoutAndRestart(context);
            },
            child: ListTile(
              title: Text(
                "Logout",
                style: TextStyle(fontSize: 20),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }
}
