import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gdg_solution/splashScreen.dart';
import 'package:gdg_solution/userpages/donate.dart';
import 'package:gdg_solution/userpages/editProfile.dart';
import 'package:gdg_solution/userpages/stateMgmt.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ContributePage extends StatefulWidget {
  const ContributePage({super.key});

  @override
  State<ContributePage> createState() => _ContributePageState();
}

class _ContributePageState extends State<ContributePage> {
  List<Map<String, dynamic>> myDonations = [];
  Future<void> refresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      myDonations = [];
    });
    getdata();
    print("Refreshed");
  }

  getdata() async {
    final provider = Provider.of<UserData>(context, listen: false);
    final firestore = FirebaseFirestore.instance;
    try {
      final mail = await FirebaseAuth.instance.currentUser!.email!;
      final data = await firestore
          .collection('users')
          .doc(mail)
          .collection('donations')
          .get();

      final docdata = data.docs.map((doc) => doc.data()).toList();

      if (mounted) {
        setState(() {
          myDonations = docdata;
        });
      }
      final nameExists = await firestore.collection('users').doc(mail).get();
      if (nameExists.data() != null && nameExists.data()!.containsKey('name')) {
        final nameMobile = await firestore.collection('users').doc(mail).get();
        provider.changeName(nameMobile['name'], nameMobile['mobile']);
      }
      // provider.changeFloat();
    } catch (e) {
      print("Error while fetching data: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error While Fetching data ($e)")),
        );
      }
    }
  }

  deleteFromFirebase(String url) async {
    final mail = await FirebaseAuth.instance.currentUser!.email!;
    final filePath = Uri.decodeFull(url.split('?').first.split('/o/').last);
    await FirebaseStorage.instance.ref(filePath).delete();
    print("Image Deleted");
    var docIds = await FirebaseFirestore.instance
        .collection('users')
        .doc(mail)
        .collection('donations')
        .where('imageUrl', isEqualTo: url)
        .get();
    for (var doc in docIds.docs) {
      await doc.reference.delete();
    }
    print("data Deleted from user DB");
    var donationIds = await FirebaseFirestore.instance
        .collection('donations')
        .where('imageUrl', isEqualTo: url)
        .get();
    print("data deleted from donation DB");
    for (var doc in donationIds.docs) {
      await doc.reference.delete();
    }

    setState(() {});
    getdata();
  }

  showProfile(BuildContext context) async {
    final provider = Provider.of<UserData>(context, listen: false);
    var name = await provider.userName;
    var mobile = await provider.userMobile;

    return showDialog(
        context: context,
        builder: (context) {
          // var name=await pr
          return AlertDialog(
            content: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Profile", style: GoogleFonts.oswald(fontSize: 35)),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfile()));
                          },
                          icon: Icon(Icons.edit))
                    ],
                  ),
                  Divider(),
                  Text(
                    "Name",
                    style: GoogleFonts.poiretOne(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(name, style: GoogleFonts.oswald(fontSize: 25)),
                  Text(
                    "Mobile No",
                    style: GoogleFonts.poiretOne(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(mobile, style: GoogleFonts.oswald(fontSize: 25)),
                  Divider(),
                  Container(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();

                          final tempDir = await getTemporaryDirectory();
                          if (tempDir.existsSync()) {
                            tempDir.deleteSync(
                                recursive: true); 
                          }

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Splashscreen()),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(Icons.logout), Text("Logout")],
                        )),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getdata();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserData>(context, listen: false);
    final avatarName = provider.userName[0].toUpperCase();
    return Scaffold(
        appBar: AppBar(
          actions: [
            GestureDetector(
                onTap: () => showProfile(context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    child: Text(avatarName),
                  ),
                ))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 70),
                Text("App Theme",
                    style: GoogleFonts.poiretOne(
                        fontWeight: FontWeight.bold, fontSize: 20)),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 100,
                          color: const Color.fromARGB(255, 69, 69, 69),
                          child: Center(
                            child: IconButton(
                                onPressed: () {
                                  provider.changeTheme(ThemeMode.light);
                                },
                                icon: Icon(
                                  Icons.light_mode,
                                  size: 50,
                                  color:
                                      const Color.fromARGB(218, 255, 255, 255),
                                )),
                          ),
                        ),
                      ),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 100,
                          color: const Color.fromARGB(255, 69, 69, 69),
                          child: Center(
                            child: IconButton(
                                onPressed: () {
                                  provider.changeTheme(ThemeMode.dark);
                                },
                                icon: Icon(Icons.dark_mode,
                                    size: 50,
                                    color: const Color.fromARGB(
                                        218, 255, 255, 255))),
                          ),
                        ),
                      ),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 100,
                          color: const Color.fromARGB(255, 69, 69, 69),
                          child: Center(
                            child: IconButton(
                                onPressed: () {
                                  provider.changeTheme(ThemeMode.system);
                                },
                                icon: Icon(Icons.settings_brightness,
                                    size: 50,
                                    color: const Color.fromARGB(
                                        218, 255, 255, 255))),
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text("My Donations",
                    style: GoogleFonts.poiretOne(
                        fontWeight: FontWeight.bold, fontSize: 20)),
                SizedBox(
                  height: 10,
                ),
                myDonations.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: myDonations.length,
                        itemBuilder: (context, idx) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                // color: Colors.white,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: myDonations[idx]['imageUrl'],
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder: (context, url,
                                                progress) =>
                                            const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            myDonations[idx]['itemName'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            myDonations[idx]['itemType'],
                                            style: TextStyle(),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "${myDonations[idx]['quantity']} Available",
                                            style: TextStyle(),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "Posted on: ${myDonations[idx]['uploadTime']}",
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        deleteFromFirebase(
                                            myDonations[idx]['imageUrl']);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "No donations found",
                        ),
                      )),
              ],
            ),
          ),
        ),
        floatingActionButton: Container(
          height: 50,
          width: 100,
          child: FloatingActionButton(
            isExtended: true,
            onPressed: () {
              final pass =
                  Provider.of<UserData>(context, listen: false).userName;
              if (pass != 'none') {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Donate()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    action: SnackBarAction(
                      label: "OK",
                      onPressed: () {},
                    ),
                    content:
                        Text("Please Edit profile before making Donation 😊")));
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.handshake),
                Text("Donate",
                    style: GoogleFonts.poiretOne(
                        fontWeight: FontWeight.bold, fontSize: 20))
              ],
            ),
          ),
        ));
  }
}
