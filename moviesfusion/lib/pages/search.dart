import 'package:flutter/material.dart';
import 'package:moviesfusion/pages/searchedmovie.dart';
import 'movie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late Future<List<Movie>> movies; // Declare movies here
  final searchController = TextEditingController(); // Move controller here

  @override
  void initState() {
    super.initState();
    movies = Future.value([]); // Initialize with an empty list
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
              padding: const EdgeInsets.fromLTRB(15, 0,0,20),
              child: Text("Search",style: TextStyle(color: Colors.white70,fontSize: 25),),
            )),

         TextField(

                style: TextStyle(color: Colors.amber),
                onSubmitted: (String query) async {
                  if (query.isNotEmpty) {
                    setState(() {
                      movies = searchMovie(query); // Await the result
                    });
                  }
                },
                controller: searchController,
                
                decoration: InputDecoration(
                
                  // focusColor: Colors.white,
                  border: OutlineInputBorder(
                    
                  ),
                  hintText: "Search movies here",
                ),
              ),

 Container(
              child: FutureBuilder<List<Movie>>(
                future: movies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); 
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text("No movies found."); 
                  } else {
                    return Searchedmovie(snapshot: snapshot.data!); 
                  }
                },
              ),
            ),


          ],
        ),
      ),
    );
  }

  Future<List<Movie>> searchMovie(String movSearch) async {
    final apiKey = "9356ab03da188fbfa0a57350654199be";
    final url = "https://api.themoviedb.org/3/search/movie?query=${movSearch}&include_adult=false&language=en-US&page=1&api_key=${apiKey}";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception("Failed to fetch movie");
    }
  }
}



// TextField(
//                 style: TextStyle(color: Colors.amber),
//                 onSubmitted: (String query) async {
//                   if (query.isNotEmpty) {
//                     setState(() {
//                       movies = searchMovie(query); // Await the result
//                     });
//                   }
//                 },
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: "Search movies here",
//                 ),
//               ),




//  Container(
//               child: FutureBuilder<List<Movie>>(
//                 future: movies,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return CircularProgressIndicator(); // Show loading indicator
//                   } else if (snapshot.hasError) {
//                     return Text("Error: ${snapshot.error}"); // Handle errors
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return Text("No movies found."); // Handle empty results
//                   } else {
//                     return Searchedmovie(snapshot: snapshot.data!); // Pass data to Searchedmovie
//                   }
//                 },
//               ),
//             ),


// FutureBuilder<List<Movie>>(
//                 future: movies,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return CircularProgressIndicator(); // Show loading indicator
//                   } else if (snapshot.hasError) {
//                     return Text("Error: ${snapshot.error}"); // Handle errors
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return Text("No movies found."); // Handle empty results
//                   } else {
//                     return Searchedmovie(snapshot: snapshot.data!); // Pass data to Searchedmovie
//                   }
//                 },
//               ),