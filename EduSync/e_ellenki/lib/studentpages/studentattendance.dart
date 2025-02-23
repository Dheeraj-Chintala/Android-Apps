import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Studentattendance extends StatefulWidget {
  const Studentattendance({super.key});

  @override
  State<Studentattendance> createState() => _StudentattendanceState();
}

class _StudentattendanceState extends State<Studentattendance> {
  final supabase = Supabase.instance.client;

  List<String> datetiles = [];
  List<Map<String, String>> subjectsList = [];
  String selectedDate = "";
  Map<String, dynamic> table = {};

  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future<void> getdata() async {
    final email = supabase.auth.currentUser?.email;
    if (email == null) return;

    final response = await supabase
        .from('students')
        .select('attendance')
        .eq('email', email)
        .maybeSingle();

    if (response != null && response.containsKey('attendance')) {
      setState(() {
        table = response['attendance'];
        datetiles = table.keys.toList();
        if (datetiles.isNotEmpty) {
          selectedDate = datetiles[0];
          getTiles(selectedDate);
        }
      });
    }
  }

  void getTiles(String date) {
    if (table.containsKey(date)) {
      setState(() {
        selectedDate = date;
        subjectsList = (table[date] as Map<String, dynamic>)
            .entries
            .map((e) => {"subject": e.key, "status": e.value.toString()})
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Color(0xFFFE7747), size: 30),
        ),
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
                  color: Color(0xFFFE7747),
                  child: Row(
                    children: [Spacer(), Image.asset("assets/attendance.png")],
                  ),
                ),
              ),
            ),
            Container(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: datetiles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => getTiles(datetiles[index]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 100,
                          color: datetiles[index] == selectedDate
                              ? Colors.orange
                              : Colors.amber,
                          child: Center(
                            child: Text(
                              datetiles[index],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: datetiles[index] == selectedDate
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            subjectsList.isEmpty
                ? Center(child: Text("No attendance records"))
                : Padding(
                    padding: EdgeInsets.all(15),
                    child: DataTable(
                      border: TableBorder.all(),
                      columns: [
                        DataColumn(label: Text('S.No')),
                        DataColumn(label: Text('Subject')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: subjectsList.asMap().entries.map((entry) {
                        int index = entry.key + 1;
                        var row = entry.value;
                        return DataRow(cells: [
                          DataCell(Text(index.toString())),
                          DataCell(Text(row['subject']!)),
                          DataCell(
                            Text(
                              row['status']!,
                              style: TextStyle(
                                color: row['status'] == "Present"
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
