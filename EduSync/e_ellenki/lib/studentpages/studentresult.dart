import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Studentresult extends StatefulWidget {
  const Studentresult({super.key});

  @override
  State<Studentresult> createState() => _StudentresultState();
}

class _StudentresultState extends State<Studentresult> {
  final supabase = Supabase.instance.client;
  late Future<Map<String, dynamic>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = getdata();
  }

  Future<Map<String, dynamic>> getdata() async {
    final email = supabase.auth.currentUser?.email;
    if (email == null) return {};

    final response = await supabase
        .from("students")
        .select("exam_result")
        .eq('email', email)
        .maybeSingle();

    if (response == null || response['exam_result'] == null) return {};
    return response['exam_result'];
  }

  List<Map<String, String>> getresult(
      Map<String, dynamic> gradesub, String sem) {
    return (gradesub[sem] as Map<String, dynamic>)
        .entries
        .map((e) => {"subject": e.key, "grade": e.value.toString()})
        .toList();
  }

  Widget returnwidget(List<Map<String, String>> subjectsList) {
    return DataTable(
      border: TableBorder.all(),
      columns: [
        DataColumn(label: Text("Subject")),
        DataColumn(label: Text("Grade")),
      ],
      rows: subjectsList
          .map((row) => DataRow(cells: [
                DataCell(Text(row['subject'].toString())),
                DataCell(Text(row['grade'].toString())),
              ]))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 254, 119, 71),
            size: 30,
          ),
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No exam results found."));
          }

          final gradesub = snapshot.data!;
          final semister = gradesub.keys.toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 150,
                      color: Color.fromARGB(255, 143, 152, 253),
                      child: Row(
                        children: [Spacer(), Image.asset("assets/result.png")],
                      ),
                    ),
                  ),
                ),
                CircularPercentIndicator(
                  circularStrokeCap: CircularStrokeCap.round,
                  startAngle: 180,
                  lineWidth: 20,
                  animation: true,
                  backgroundColor: Color.fromARGB(255, 143, 152, 253),
                  percent: 0.5,
                  progressColor: Color.fromARGB(255, 83, 97, 255),
                  radius: 100,
                  center: Text("7.5 GPA"),
                ),
                SizedBox(
                  height: 30,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: semister.length,
                  itemBuilder: (context, index) {
                    final subjectsList = getresult(gradesub, semister[index]);
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(semister[index],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        returnwidget(subjectsList),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
