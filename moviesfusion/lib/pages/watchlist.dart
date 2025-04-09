import 'package:flutter/material.dart';
import 'movie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'series.dart';
class Watchlist extends StatefulWidget {
  const Watchlist({super.key});

  @override
  State<Watchlist> createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {

late Future<List<Movie>> seriesdata;
@override
  void initState() {
    
    super.initState();
    seriesdata=seriesfun();

  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 31, 31),

      body: SingleChildScrollView(
        child: Column(
          children: [
 Container(
            height: 60,
      
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0,0,0),
              child: Text("Trending Series",style: TextStyle(color: Colors.white70,fontSize: 25),),
            )),
         
            Container(
              child: FutureBuilder<List<Movie>>(
                future: seriesdata,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(); 
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text("No movies found."); 
                  } else {
                    return Series(snapshot: snapshot.data!); 
                  }
                },
              ),
            ),
            
          ],
        ),
      ),
    );
  }


  Future<List<Movie>> seriesfun() async {
    final apikey = "9356ab03da188fbfa0a57350654199be";
    final url = "https://api.themoviedb.org/3/trending/tv/day?language=en-US&page=1&api_key=${apikey}";
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