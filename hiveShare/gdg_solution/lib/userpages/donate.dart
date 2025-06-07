import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gdg_solution/userpages/stateMgmt.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Donate extends StatefulWidget {
  const Donate({super.key});

  @override
  State<Donate> createState() => _DonateState();
}

class _DonateState extends State<Donate> {
  var itemName = TextEditingController();
  var itemType = TextEditingController();
  var itemDesc = TextEditingController();
  var itemQuantity = TextEditingController();
  var expireTime = TextEditingController();
  String imageUrl = '';
  bool timeBool = false;
  bool imageBool = false;
  List<String> itemtypes = ["Food", "Books", "Clothes", "Electronics"];
  File? imagePath;
  var picker = ImagePicker();

  pickImage(String sourcePath) async {
    var pickedFile = await picker.pickImage(
      source:
          sourcePath == 'gallery' ? ImageSource.gallery : ImageSource.camera,
    );

    if (pickedFile != null) {
      File compressedFile = await compressImage(File(pickedFile.path));

      setState(() {
        imagePath = compressedFile;
        imageBool = true;
      });
    }
  }

  Future<File> compressImage(File file) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      file.absolute.path + "_compressed.jpg",
      quality: 50,
      format: CompressFormat.jpeg,
      minWidth: 800,
      minHeight: 800,
    );

    return File(result!.path);
  }

  uploadImageAndUrl() async {
    if (imagePath == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please select an image")));
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      File compressedImage = await compressImage(imagePath!);
      var filename = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef =
          FirebaseStorage.instance.ref().child('uploads/$filename.jpg');

      UploadTask uploadTask = storageRef.putFile(compressedImage);
      TaskSnapshot snapshot = await uploadTask;
      String url = await snapshot.ref.getDownloadURL();

      setState(() {
        imageUrl = url;
      });

      uploadtoFirebase();
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  uploadtoFirebase() async {
    try {
      final userloc =
          Provider.of<UserData>(context, listen: false).userlocation;
      final userMail = await FirebaseAuth.instance.currentUser!.email!;
      final username = Provider.of<UserData>(context, listen: false).userName;
      final userMobile =
          Provider.of<UserData>(context, listen: false).userMobile;
      await FirebaseFirestore.instance.collection('donations').add({
        'itemName': itemName.text,
        'itemType': itemType.text,
        'itemDesc': itemDesc.text,
        'quantity': itemQuantity.text,
        'imageUrl': imageUrl,
        'uploadTime': DateTime.now().toIso8601String().split('T').first,
        'donor': username,
        'location': {
          'longitude': userloc['longitude'],
          'latitude': userloc['latitude']
        },
        'mobile': userMobile
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userMail)
          .collection('donations')
          .add({
        'itemName': itemName.text,
        'itemType': itemType.text,
        'itemDesc': itemDesc.text,
        'quantity': itemQuantity.text,
        'imageUrl': imageUrl,
        'uploadTime': DateTime.now().toIso8601String().split('T').first,
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Post uploaded")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 70),
            Container(
                child: imageBool
                    ? Image(
                        image: FileImage(imagePath!),
                        height: 300,
                        width: 300,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.image,
                        size: 200,
                      )),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: itemName,
                decoration: InputDecoration(
                  labelText: "Item Name",
                  hintText: "EX: Books",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: itemType,
                decoration: InputDecoration(
                  labelText: "Item Type",
                  hintText: "EX: Books",
                  border: OutlineInputBorder(),
                  suffixIcon: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          items: itemtypes.map((String item) {
                            return DropdownMenuItem(
                                value: item, child: Text(item));
                          }).toList(),
                          onChanged: (String? newval) {
                            itemType.text = newval!;
                            setState(() {
                              timeBool = newval == "Food";
                            });
                          })),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: itemDesc,
                decoration: InputDecoration(
                  labelText: "Description",
                  hintText: "Brief about item",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Visibility(
              visible: timeBool,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: expireTime,
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                    labelText: "Food available time",
                    hintText: "In Hours",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: itemQuantity,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  labelText: "Quantity",
                  hintText: "Available no of items or quantity",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                  // backgroundColor: const Color.fromARGB(255, 42, 42, 42),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
                  onPressed: () => pickImage("gallery"),
                  icon: Icon(Icons.file_copy),
                  label: Text("Add File"),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                  // backgroundColor:  const Color.fromARGB(255, 42, 42, 42),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
                  onPressed: () => pickImage("camera"),
                  icon: Icon(Icons.camera),
                  label: Text("Add Capture"),
                ),
              ],
            ),
            SizedBox(height: 30,),
            Container(
              height: 70,
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  // backgroundColor: const Color.fromARGB(255, 62, 62, 62),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
                onPressed: uploadImageAndUrl,
                icon: Icon(Icons.handshake),
                label: Text("Donate"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
