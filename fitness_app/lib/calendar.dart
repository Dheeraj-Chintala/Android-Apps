import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  void initState() {
    super.initState();
    getprogress();
  }

  getprogress() async {
    try {
      final supabase = Supabase.instance.client;
      final mail = supabase.auth.currentUser!.email!;
      final responseDates = [];
      final response = await supabase
          .from('progress')
          .select()
          .eq('email', mail);
      setState(() {
        progressData = response;
      });
      for (var i = 0; i < response.length; i++) {
        responseDates.add(response[i]['date']);
      }
      print(progressData);
      dates = {for (var i in responseDates) DateTime.parse(i): 1};
    } catch (e) {
      print(e.toString());
    }
  }

  Map<DateTime, int> dates = {};
  List<Map<String, dynamic>> progressData = [];
  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  calendarClick(DateTime value) {
    final formatedDate = formatDate(value);

    final Map<String, dynamic>? matchedRow = progressData.firstWhere(
      (row) => row['date'] == formatedDate,
      orElse: () => <String, dynamic>{},
    );
    if (matchedRow!.isNotEmpty) {
      print(matchedRow);
      showDialog(
        context: context,
        builder: (context) {
          final exercisesDone = matchedRow['exercisesdone'];
          final calorieBurnt =
              matchedRow['caloriespent'].toString().split('.').first;
          return AlertDialog(
            backgroundColor: const Color.fromARGB(160, 67, 148, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              "Exercises done : $exercisesDone \nCalories burnt: $calorieBurnt",
              style: GoogleFonts.ptSans(),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Progress Tracker",
            style: GoogleFonts.bebasNeue(
              color: const Color.fromARGB(127, 38, 255, 0),
              fontSize: 35,
            ),
          ),
          HeatMap(
            startDate: DateTime.now().subtract(Duration(days: 15)),
            endDate: DateTime.now(),
            datasets: dates,
            colorMode: ColorMode.opacity,
            showText: true,
            textColor: const Color.fromARGB(255, 255, 255, 255),
            defaultColor: const Color.fromARGB(133, 78, 78, 78),
            showColorTip: false,
            scrollable: true,
            size: 60,
            colorsets: {1: Color.fromARGB(238, 19, 125, 0)},
            onClick: (value) => calendarClick(value),
          ),
        ],
      ),
    );
  }
}
