import 'package:e_ellenki/pages/login.dart';
import 'package:flutter/material.dart';

class Getstarted extends StatefulWidget {
  const Getstarted({super.key});

  @override
  State<Getstarted> createState() => _GetstartedState();
}

class _GetstartedState extends State<Getstarted> {
  var colorchange =
      WidgetStatePropertyAll<Color>(const Color.fromARGB(255, 19, 45, 145));
  var antothercolor =
      WidgetStatePropertyAll<Color>(const Color.fromARGB(255, 255, 255, 255));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/Vector.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                    child: Image.asset(
                      'assets/people.png',
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Image.asset("assets/logowithname.png"),
            ),
            Text(
              "Student academic needs",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 70,
            ),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                          const Color.fromARGB(255, 254, 119, 71))),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Text(
                    "Get Started",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  )),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Spacer(),
                OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: antothercolor,
                    ),
                    onPressed: () {
                      setState(() {
                        colorchange = WidgetStatePropertyAll<Color>(
                            const Color.fromARGB(255, 255, 255, 255));
                        antothercolor = WidgetStatePropertyAll<Color>(
                            const Color.fromARGB(255, 19, 45, 145));
                      });
                    },
                    child: Text(
                      "Admin",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 254, 119, 71),
                          fontSize: 20),
                    )),
                // Spacer(),
                OutlinedButton(
                    style: ButtonStyle(backgroundColor: colorchange),
                    onPressed: () {
                      setState(() {
                        colorchange = WidgetStatePropertyAll<Color>(
                            const Color.fromARGB(255, 19, 45, 145));
                        antothercolor = WidgetStatePropertyAll<Color>(
                            const Color.fromARGB(255, 255, 255, 255));
                      });
                    },
                    child: Text("Student",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 254, 119, 71),
                            fontSize: 20))),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
