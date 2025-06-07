import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserData extends ChangeNotifier {
  //vars
  Map<String, double> userLocation = {'longitude': 555, 'latitude': 444};
  List<Map<String, dynamic>> donationData = [];
  String username="none";
  String usermobile="none";
  String filtervar="All";
  bool floatvisible=true;
  ThemeMode usertheme=ThemeMode.system;

  //getters
  List<Map<String, dynamic>> get donationdata => donationData;
  Map<String, double> get userlocation => userLocation;
  String get filterVar=>filtervar;
  String get userName=>username;
  String get userMobile=>usermobile;
  bool get floatVisible=>floatvisible;
  ThemeMode get userTheme=>usertheme;

  //Fns
  changeLocation(double long, double lat) {
    userLocation = {'longitude': long, 'latitude': lat};

    notifyListeners();
  }
  changeFloat(){
    floatvisible=floatVisible==true? floatvisible=false: floatvisible=true;
    notifyListeners();
  }
 changeTheme(ThemeMode mode){
   usertheme=mode;
   notifyListeners();
 }
  changefilter(String fil){
   filtervar=fil;
   notifyListeners();
  }
  changeName(String name,String mobile){
    username=name;
    usermobile=mobile;
    notifyListeners();
  }
  fetchDonations() async {

    try {
      final donations =
          await FirebaseFirestore.instance.collection('donations').get();
      final donationdocs = donations.docs.map((doc) => doc.data()).toList();
      donationData.clear();
      donationData = donationdocs;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
