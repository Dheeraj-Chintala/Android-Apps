import 'package:e_ellenki/adminpages/libraraybooks.dart';
import 'package:e_ellenki/adminpages/librarydetails.dart';
import 'package:flutter/material.dart';

class Librarypage extends StatefulWidget {
  const Librarypage({super.key});

  @override
  State<Librarypage> createState() => _LibrarypageState();
}

class _LibrarypageState extends State<Librarypage> {
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
                      color: const Color.fromARGB(255, 143, 152, 253),
                      child: Row(
                        children: [Spacer(), Image.asset("assets/library.png")],
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
                        text: "Details",
                      ),
                      Tab(
                        text: "Books Issued",
                      )
                    ]),
                SizedBox(
                  height: 900,
                  child: TabBarView(children: [
                    Librarydetails(),
                    Libraraybooks(),
                  ]),
                ),
              ],
            ),
          ),
        ));
  }
}
