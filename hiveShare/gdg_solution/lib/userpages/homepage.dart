import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gdg_solution/userpages/contribute.dart';
import 'package:gdg_solution/userpages/map.dart';
import 'package:gdg_solution/userpages/stateMgmt.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int selectedindex = 0;
  bottomnavchange(int index) {
    Provider.of<UserData>(context, listen: false).changeFloat();
    setState(() {
      selectedindex = index;
    });
  }

  List<Widget> pages = [
    MapPage(),
    ContributePage(),
  ];
  void openWhatsApp(String phoneNumber, String message) async {
    String url =
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";

    try {
      if (await canLaunch(url)) {
        await launch(url);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void openGoogleMapsDirections(String latitude, String longitude) async {
    final Uri googleMapsDirectionsUrl = Uri.parse(
        "https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude");

    if (await canLaunchUrl(googleMapsDirectionsUrl)) {
      await launchUrl(googleMapsDirectionsUrl);
    } else {
      throw "Could not open Google Maps for directions";
    }
  }

  showInfo(Map<String, dynamic> data, BuildContext context) {
    return showDialog(
        barrierColor: const Color.fromARGB(164, 0, 0, 0),
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? const Color.fromARGB(255, 184, 221, 255)
                  : const Color.fromARGB(255, 87, 89, 93),
              content: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: data['imageUrl'],
                          height: 300,
                          width: 300,
                          fit: BoxFit.cover,
                        )),
                    Text("Name", style: GoogleFonts.poiretOne(fontSize: 20)),
                    Text(data['itemName'],
                        style: GoogleFonts.roboto(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    Text("Type", style: GoogleFonts.poiretOne(fontSize: 20)),
                    Text(data['itemType'],
                        style: GoogleFonts.roboto(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    Text("Description",
                        style: GoogleFonts.poiretOne(fontSize: 20)),
                    Text(data['itemDesc'],
                        style: GoogleFonts.roboto(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    Text("Donor", style: GoogleFonts.poiretOne(fontSize: 20)),
                    Text(data['donor'],
                        style: GoogleFonts.roboto(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    Text("Posted On",
                        style: GoogleFonts.poiretOne(fontSize: 20)),
                    Text(data['uploadTime'],
                        style: GoogleFonts.roboto(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    Divider(),
                    Row(
                      children: [
                        Spacer(),
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            icon: Icon(Icons.directions),
                            onPressed: () {
                              openGoogleMapsDirections(
                                  data['location']['latitude'].toString(),
                                  data['location']['longitude'].toString());
                            },
                            label: Text("Directions")),
                        Spacer(),
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            icon: Icon(Icons.message),
                            onPressed: () {
                              openWhatsApp("+91${data['mobile']}",
                                  "Hello! 👋\nI am interested in accepting donation of *${data['itemName']}* I'd be happy to coordinate the pickup!\nThank you 🙏");
                            },
                            label: Text("Message")),
                        Spacer()
                      ],
                    )
                  ],
                ),
              ));
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final provider = Provider.of<UserData>(context, listen: false);
    provider.fetchDonations();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserData>(context, listen: false);

    Color containerColor = Theme.of(context).brightness == Brightness.light
        ? const Color.fromARGB(255, 184, 221, 255)
        : const Color.fromARGB(255, 87, 89, 93);
    return Scaffold(
      body: pages[selectedindex],
      bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          unselectedItemColor: Color.fromARGB(185, 91, 88, 85),
          currentIndex: selectedindex,
          onTap: bottomnavchange,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_rounded,
                ),
                label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
          ]),
      floatingActionButton: Visibility(
        visible: provider.floatVisible,
        child: FloatingActionButton(
          onPressed: () async {
            var userLoc =
                Provider.of<UserData>(context, listen: false).userLocation;
            double? userLat = userLoc['latitude'];
            double? userLng = userLoc['longitude'];
            showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) {
                return Consumer<UserData>(
                  builder: (context, userData, child) {
                    List<Map<String, dynamic>> donation = userData.donationdata;
                    List<Map<String, dynamic>> filterdata = [];
                    String filterchip = userData.filterVar;

                    if (filterchip == "All") {
                      filterdata = donation;
                    } else {
                      filterdata = donation
                          .where((doc) => doc['itemType'] == filterchip)
                          .toList();
                    }
                    filterdata.sort((a, b) {
                      double latA = a['location']['latitude'];
                      double lngA = a['location']['longitude'];
                      double latB = b['location']['latitude'];
                      double lngB = b['location']['longitude'];

                      double distanceA = Geolocator.distanceBetween(
                          userLat!, userLng!, latA, lngA);
                      double distanceB = Geolocator.distanceBetween(
                          userLat, userLng, latB, lngB);

                      return distanceA.compareTo(distanceB);
                    });

                    return DraggableScrollableSheet(
                      initialChildSize: 0.4,
                      minChildSize: 0.1,
                      maxChildSize: 1,
                      expand: true,
                      builder: (context, scontroller) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: containerColor,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 5)
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 5,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  controller: scontroller,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: filterdata.length,
                                  itemBuilder: (context, idx) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () =>
                                            showInfo(filterdata[idx], context),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                imageUrl: filterdata[idx]
                                                    ['imageUrl'],
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.cover,
                                                progressIndicatorBuilder: (context,
                                                        url, progress) =>
                                                    Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    filterdata[idx]['itemName'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    filterdata[idx]['itemType'],
                                                    style: TextStyle(),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    filterdata[idx]
                                                            ['quantity'] +
                                                        " Available",
                                                    style: TextStyle(),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    "Posted on: ${filterdata[idx]['uploadTime']}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10))),
                                                onPressed: () {
                                                  openWhatsApp(
                                                      "+91${filterdata[idx]['mobile']}",
                                                      "Hello! 👋\nI am interested in accepting donation of *${filterdata[idx]['itemName']}* I’d be happy to coordinate the pickup!\nThank you 🙏");
                                                },
                                                child: Text("Accept"))
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
          child: Icon(
            Icons.keyboard_arrow_up,
            size: 40,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
