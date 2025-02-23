import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';

class Librarydetails extends StatefulWidget {
  const Librarydetails({super.key});

  @override
  State<Librarydetails> createState() => _LibrarydetailsState();
}

class _LibrarydetailsState extends State<Librarydetails> {
  final dataMap = <String, double>{
    "Total Books": 4000,
    "Returned": 150,
    "Books Issued": 200,
    "Not Submitted": 50
  };

  final colorList = <Color>[
    const Color.fromARGB(255, 88, 101, 247),
    const Color.fromARGB(255, 139, 113, 211),
    const Color.fromARGB(255, 24, 43, 136),
    const Color.fromARGB(107, 139, 113, 211),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            Align(
                alignment: Alignment.center,
                child: Text("Books Stats",
                    style: GoogleFonts.roboto(fontSize: 25))),
            Center(
              child: PieChart(
                dataMap: dataMap,
                animationDuration: Duration(milliseconds: 1000),
                chartLegendSpacing: 32,
                chartRadius: MediaQuery.of(context).size.width / 1.5,
                colorList: colorList,
                initialAngleInDegree: 0,
                chartType: ChartType.disc,
                ringStrokeWidth: 20,
                // centerText: "Books Stats",
                legendOptions: LegendOptions(
                  showLegendsInRow: false,
                  legendPosition: LegendPosition.bottom,
                  showLegends: true,
                  legendShape: BoxShape.rectangle,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                chartValuesOptions: ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: false,
                  showChartValuesOutside: true,
                  decimalPlaces: 0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
