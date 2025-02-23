import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Pastevents extends StatefulWidget {
  const Pastevents({super.key});

  @override
  State<Pastevents> createState() => _PasteventsState();
}

class _PasteventsState extends State<Pastevents> {
  final name = TextEditingController();
  final venue = TextEditingController();
  final date = TextEditingController();
  final timings = TextEditingController();
  var imagelink = "";
  var selectedDate = DateTime.now();
  selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        date.text = picked.toString();
      });
    }
  }

  Future<String?> uploadImageToSupabase(String name) async {
    final supabase = Supabase.instance.client;
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return null;

      File file = File(image.path);
      String fileName = name + ".jpg";

      await supabase.storage.from('notificationimages').upload(fileName, file);

      final imageUrl =
          supabase.storage.from('notificationimages').getPublicUrl(fileName);

      print("Image Uploaded: $imageUrl");
      return imageUrl;
    } catch (error) {
      print(" Error uploading image: $error");
      return null;
    }
  }

  uploadtodb(String ename, String evenue, String edate, String etimings,
      String eimagelink) async {
    final supabase = Supabase.instance.client;
    try {
      await supabase.from('events').insert({
        'eventname': ename,
        'venue': evenue,
        'date': edate,
        'timings': etimings,
        'imagelink': eimagelink
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Align(
                alignment: Alignment.center,
                child: Text("Event Details",
                    style: GoogleFonts.roboto(
                        fontSize: 30,
                        color: const Color.fromARGB(255, 19, 45, 145)))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.broken_image,
                    size: 50,
                  );
                },
                imagelink,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: venue,
                decoration: InputDecoration(
                    labelText: "Venue",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: date,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                      initialDate: DateTime.now(),
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2026));
                  setState(() {
                    date.text = picked.toString().split(" ").first;
                  });
                },
                decoration: InputDecoration(
                    labelText: "Date",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: timings,
                decoration: InputDecoration(
                    labelText: "Timings",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () async {
                      String? imageurl = await uploadImageToSupabase(name.text);
                      setState(() {
                        imagelink = imageurl ?? "kook";
                      });
                    },
                    child: Text("Upload image"))),
            Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll<Color>(
                              const Color.fromARGB(255, 19, 45, 145))),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Center(child: CircularProgressIndicator());
                            });
                        await uploadtodb(name.text, venue.text, date.text,
                            timings.text, imagelink);

                        name.clear();
                        venue.clear();
                        date.clear();
                        timings.clear();
                        setState(() {
                          imagelink = "";
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Upload",
                        style: TextStyle(color: Colors.white),
                      )),
                ))
          ],
        ),
      ),
    );
  }
}
