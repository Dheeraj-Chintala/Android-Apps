import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Libraraybooks extends StatefulWidget {
  const Libraraybooks({super.key});

  @override
  State<Libraraybooks> createState() => _LibraraybooksState();
}

class _LibraraybooksState extends State<Libraraybooks> {
  List Books = [];
  getdata() async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase.from('library_books').select();
      setState(() {
        Books = response;
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
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DataTable(
                  columnSpacing: double.minPositive,
                  border: TableBorder.all(),
                  columns: [
                    DataColumn(label:  Text("S.No")),
                    DataColumn(label: Text("Student")),
                    DataColumn(label: Text("Book Name")),
                    DataColumn(label: Text("Dept")),
                  ],
                  rows: Books.map(
                    (row) => DataRow(cells: [
                      DataCell(Text(row['id'].toString())),
                      DataCell(Text(row['name'])),
                      DataCell(Text(row['book_name'])),
                      DataCell(Text(row['dept'])),
                    ]),
                  ).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
