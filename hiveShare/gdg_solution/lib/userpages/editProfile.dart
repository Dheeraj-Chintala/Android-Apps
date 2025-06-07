import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdg_solution/userpages/stateMgmt.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController name = TextEditingController();
  TextEditingController mobile = TextEditingController();
  submitData(String name, String mobile) async {
    final provider = Provider.of<UserData>(context, listen: false);
    final user = await FirebaseAuth.instance.currentUser!.email!;
    await provider.changeName(name, "+91 " + mobile);

    try {
      await FirebaseFirestore.instance.collection('users').doc(user).set({
        'name': name,
        'mobile': mobile,
      }, SetOptions(merge: true));
    } catch (e) {
      return ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: name,
              decoration: InputDecoration(
                  labelText: "Name", border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: mobile,
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(
                  labelText: "Mobile No", border: OutlineInputBorder()),
            ),
          ),
          Container(
            height: 60,
            width: double.infinity,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 66, 66, 66),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  submitData(name.text, mobile.text);
                  name.clear();
                  mobile.clear();
                },
                child: Text("Done")),
          )
        ],
      ),
    );
  }
}
