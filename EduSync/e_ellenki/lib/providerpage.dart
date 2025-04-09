import 'package:flutter/material.dart';

class Providerpage extends ChangeNotifier {
  int todaypresent = 0;
  int total = 0;
  String presentclass = 'CSE';
  updateclass(
      {
      required int dailypresent,
      required int dailycount}) {
    todaypresent = dailypresent;
    total = dailycount;
 
    notifyListeners();
  }

}
