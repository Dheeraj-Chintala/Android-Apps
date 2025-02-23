import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Timetablesched extends StatefulWidget {
  const Timetablesched({super.key});

  @override
  State<Timetablesched> createState() => _TimetableschedState();
}

class _TimetableschedState extends State<Timetablesched> {
  List table = [];
  getdata() async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase.from('exam_schedules').select();
      setState(() {
        table = response;
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    border: TableBorder.all(),
                    columns: [
                      DataColumn(label: Text('S.No')),
                      DataColumn(label: Text('Subject')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Timings')),
                    ],
                    rows: table
                        .map((row) => DataRow(cells: [
                              DataCell(Text(row['id'].toString())),
                              DataCell(Text(row['subject'])),
                              DataCell(Text(row['date'])),
                              DataCell(Text(row['timings'])),
                            ]))
                        .toList()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
