import 'package:e_ellenki/providerpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class Reportattendance extends StatefulWidget {
  const Reportattendance({super.key});

  @override
  State<Reportattendance> createState() => _ReportattendanceState();
}

class _ReportattendanceState extends State<Reportattendance> {
  @override
  Widget build(BuildContext context) {
    final providerclass = Provider.of<Providerpage>(context);
    double percentage = (providerclass.todaypresent / providerclass.total);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Align(
                alignment: Alignment.center,
                child: Text("Daily Report",
                    style: GoogleFonts.roboto(fontSize: 30))),
            SizedBox(
              height: 30,
            ),
            Container(
                child: CircularPercentIndicator(
              backgroundColor: const Color.fromARGB(255, 254, 119, 71),
              animation: true,
              progressColor: const Color.fromARGB(255, 19, 45, 145),
              radius: 140,
              percent: percentage,
              startAngle: 180,
              animationDuration: 1000,
              lineWidth: 40,
              center: Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: providerclass.todaypresent.toString(),
                      style: GoogleFonts.bebasNeue(fontSize: 30)),
                  TextSpan(text: "/${providerclass.total} are Present")
                ]),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
