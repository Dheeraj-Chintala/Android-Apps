import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Studentsched extends StatefulWidget {
  const Studentsched({super.key});

  @override
  State<Studentsched> createState() => _StudentschedState();
}

class _StudentschedState extends State<Studentsched> {
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
        ],      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 150,
                  color: const Color.fromARGB(255, 255, 195, 120),
                  child: Row(
                    children: [Spacer(), Image.asset("assets/examsched.png")],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
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
