import 'package:e_ellenki/adminpages/pastevents.dart';
import 'package:e_ellenki/adminpages/upcomingevents.dart';
import 'package:flutter/material.dart';

class Eventspage extends StatefulWidget {
  const Eventspage({super.key});

  @override
  State<Eventspage> createState() => _EventspageState();
}

class _EventspageState extends State<Eventspage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
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
                      color: const Color.fromARGB(255, 19, 45, 145),
                      child: Row(
                        children: [Spacer(), Image.asset("assets/events.png")],
                      ),
                    ),
                  ),
                ),
                TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    unselectedLabelColor: const Color.fromARGB(95, 0, 0, 0),
                    tabs: [
                      Tab(
                        text: "Upcoming Events",
                      ),
                      Tab(
                        text: "Post Events",
                      )
                    ]),
                SizedBox(
                  height: 900,
                  child: TabBarView(children: [Upcomingevents(), Pastevents()]),
                ),
              ],
            ),
          ),
        ));
  }
}
