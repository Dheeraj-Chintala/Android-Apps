import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:moviesfusion/pages/account.dart';
import 'package:moviesfusion/pages/home.dart';
import 'package:moviesfusion/pages/movie.dart';
import 'package:moviesfusion/pages/search.dart';
import 'package:moviesfusion/pages/watchlist.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int navindex = 0;

  void bottomnavchange(int index) {
    setState(() {
      navindex = index;
    });
  }

  late Future<List<Movie>> nowplayingdata;
  late Future<List<Movie>> upcomingdata;
  late Future<List<Movie>> toprateddata;
  late Future<List<Movie>> populardata;
  @override
  void initState() {
    super.initState();
  
    nowplayingdata= apidata().nowplaying(); 
    upcomingdata=apidata().upcoming();
    toprateddata=apidata().toprated();
    populardata=apidata().popular();
  }

  final List<Widget> otherPages = [
    Search(),
    Watchlist(),
    Account()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 32, 31, 31),

      body: navindex == 0 
          ? home()
          : otherPages[navindex - 1],

          
           
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BottomNavigationBar(
          showUnselectedLabels: false,
          currentIndex: navindex,
          onTap: bottomnavchange,
          backgroundColor: const Color.fromARGB(255, 32, 31, 31),
          selectedItemColor: const Color.fromARGB(255, 239, 239, 239),
          unselectedItemColor: const Color.fromARGB(255, 187, 187, 187),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(icon: Icon(Icons.movie), label: "TV series"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
          ],
        ),
      ),
    );
  }
}

class apidata {


  Future<List<Movie>> nowplaying() async {
    final apikey = "9356ab03da188fbfa0a57350654199be";
    final url = "https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=1&api_key=${apikey}";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("Data fetching...");
      final decodeddata = json.decode(response.body)['results'] as List;
      print("Data fetched");
      return decodeddata.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception("Failed to fetch Data");
    }
  }

  Future<List<Movie>> upcoming() async {
    final apikey = "9356ab03da188fbfa0a57350654199be";
    final url = "https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=1&api_key=${apikey}";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("Data fetching...");
      final decodeddata = json.decode(response.body)['results'] as List;
      print("Data fetched");
      return decodeddata.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception("Failed to fetch Data");
    }
  }



  Future<List<Movie>> toprated() async {
    final apikey = "9356ab03da188fbfa0a57350654199be";
    final url = "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1&api_key=${apikey}";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("Data fetching...");
      final decodeddata = json.decode(response.body)['results'] as List;
      print("Data fetched");
      return decodeddata.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception("Failed to fetch Data");
    }
  }



  Future<List<Movie>> popular() async {
    final apikey = "9356ab03da188fbfa0a57350654199be";
    final url = "https://api.themoviedb.org/3/movie/popular?language=en-US&page=1&api_key=${apikey}";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("Data fetching...");
      final decodeddata = json.decode(response.body)['results'] as List;
      print("Data fetched");
      return decodeddata.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception("Failed to fetch Data");
    }
  }



}