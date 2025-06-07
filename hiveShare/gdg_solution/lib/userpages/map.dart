import 'package:flutter/material.dart';
import 'package:gdg_solution/userpages/stateMgmt.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController gmapcontroller;
  Set<Marker> pins = {};
  LatLng livelocation = LatLng(17.3850, 78.4867);
  MapType myMap = MapType.normal;
  double mapTilt = 90;

  Future<BitmapDescriptor> getCustomMarker(String assetPath) async {
    return BitmapDescriptor.asset(
        ImageConfiguration(size: Size(80, 80)), assetPath);
  }

  addPin(LatLng position, String title, String snippet, BitmapDescriptor icon) {
    pins.add(Marker(
      markerId: MarkerId(position.toString()),
      position: position,
      infoWindow: InfoWindow(title: title, snippet: snippet),
      icon: icon,
    ));
  }

  getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (!mounted) return;

    setState(() {
      livelocation = LatLng(position.latitude, position.longitude);
    });

    final donation = Provider.of<UserData>(context, listen: false).donationdata;

    for (var doc in donation) {
      String itemType = doc['itemType'];
      BitmapDescriptor icon;

      if (itemType == "Food") {
        icon = await getCustomMarker("assets/foodPing.png");
      } else if (itemType == "Clothes") {
        icon = await getCustomMarker("assets/clothesPing.png");
      } else if (itemType == "Books") {
        icon = await getCustomMarker("assets/booksPing.png");
      } else if (itemType == "Electronics") {
        icon = await getCustomMarker("assets/electronicsPing.png");
      } else {
        icon = await getCustomMarker("assets/defaultPing.png");
      }

      addPin(LatLng(doc['location']['latitude'], doc['location']['longitude']),
          doc['itemType'], doc['itemType'], icon);
    }

    setState(() {});

    Provider.of<UserData>(context, listen: false)
        .changeLocation(position.longitude, position.latitude);

    print(position);
  }

  filterFn(String filter) async {
    pins.clear();
    final donation = Provider.of<UserData>(context, listen: false).donationdata;
    Provider.of<UserData>(context, listen: false).changefilter(filter);
    for (var doc in donation) {
      String itemType = doc['itemType'];
      BitmapDescriptor icon;

      if (itemType == "Food") {
        icon = await getCustomMarker("assets/foodPing.png");
      } else if (itemType == "Clothes") {
        icon = await getCustomMarker("assets/clothesPing.png");
      } else if (itemType == "Books") {
        icon = await getCustomMarker("assets/booksPing.png");
      } else if (itemType == "Electronics") {
        icon = await getCustomMarker("assets/electronicsPing.png");
      } else {
        icon = await getCustomMarker("assets/defaultPing.png");
      }
      if (doc['itemType'] == filter) {
        addPin(
            LatLng(doc['location']['latitude'], doc['location']['longitude']),
            doc['itemType'],
            doc['itemType'],
            icon);
      }
      if (filter == "All") {
        addPin(
            LatLng(doc['location']['latitude'], doc['location']['longitude']),
            doc['itemType'],
            doc['itemType'],
            icon);
      }
    }
    setState(() {});
  }

  moveToMyLoc() {
    gmapcontroller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: livelocation,
          zoom: 20,
          bearing: 0,
          tilt: mapTilt,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (pins.isEmpty) {
      getLocation();
    }
  }

  moreMenu(String menuItem) {
    switch (menuItem) {
      case "satellite":
        setState(() {
          mapTilt = 0;
          moveToMyLoc();
          myMap = MapType.hybrid;
        });
        break;
      case "3d":
        setState(() {
          myMap = MapType.normal;

          mapTilt = 90;
          moveToMyLoc();
        });
        break;
      default:
        setState(() {
          mapTilt = 0;
          myMap = MapType.normal;
          moveToMyLoc();
        });
    }
  }

  refersh() {
    final provider = Provider.of<UserData>(context, listen: false);

    pins.clear();
    getLocation();
    provider.fetchDonations();
    moveToMyLoc();
  }

  List filters = ["All", "Food", "Clothes", "Books", "Electronics"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 10,
        title: Row(
          children: [
            Image.asset(
              "assets/gdlogo.png",
              height: 40,
            ),
            Text("HiveShare", style: GoogleFonts.offside(fontSize: 20))
          ],
        ),
        actions: [
          IconButton(
              onPressed: refersh,
              icon: Icon(
                Icons.refresh,
              )),
          PopupMenuButton(
              borderRadius: BorderRadius.circular(20),
              elevation: 30,
              offset: Offset(0, 50),
              icon: Icon(
                Icons.more_vert_rounded,
              ),
              onSelected: (value) {
                moreMenu(value);
                print(value);
              },
              itemBuilder: (context) => <PopupMenuEntry>[
                    PopupMenuItem(enabled: false, child: Text("Map")),
                    PopupMenuDivider(
                      height: 0,
                    ),
                    PopupMenuItem(
                        value: "satellite",
                        child: ListTile(
                          leading: Icon(Icons.satellite_alt),
                          title: Text("Satellite View"),
                        )),
                    PopupMenuItem(
                        value: "3d",
                        child: ListTile(
                          leading: Icon(Icons.threed_rotation_rounded),
                          title: Text("3D View"),
                        )),
                    PopupMenuItem(
                        value: "default",
                        child: ListTile(
                          leading: Icon(Icons.width_normal_outlined),
                          title: Text("Default View"),
                        )),
                  ])
        ],
      ),
      body: Stack(children: [
        GoogleMap(
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          mapType: myMap,
          markers: pins,
          initialCameraPosition:
              CameraPosition(target: livelocation, zoom: 20, tilt: mapTilt),
          onMapCreated: (controller) {
            gmapcontroller = controller;
            Future.delayed(Duration(seconds: 1));
            moveToMyLoc();
          },
        ),
        Column(
          children: [
            SizedBox(
              height: 5,
            ),
            Container(
              height: 50,
              width: double.infinity,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 3, vertical: 3),
                      child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: () {
                                filterFn(filters[index]);
                              },
                              child: Text(
                                filters[index],
                                style: GoogleFonts.roboto(fontSize: 18),
                              ))),
                    );
                  }),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 60),
            child: FloatingActionButton(
              onPressed: () {
                moveToMyLoc();
              },
              child: Icon(
                Icons.location_searching,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
