
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviesfusion/pages/movie.dart';
import 'infopage.dart';
class cinetiles extends StatelessWidget {
  const cinetiles({
    super.key,
    required this.category,
    required this.snapshot,
  });
final String category;
final List<Movie> snapshot;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 30,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0,0,0),
            child: Container(
              child: Text(category,style: TextStyle(color: Colors.white70),),
            ),
          ),
        ),
        Container(
          height: 200,
          
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection:Axis.horizontal,
            itemCount: snapshot.length,
            itemBuilder:(context,index){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    
                      color: const Color.fromARGB(255, 58, 54, 54),
                      child: SizedBox(
                    height: 200,
                    width: 150,
                 child: GestureDetector(
                   onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context)=>Infopage(title:snapshot[index].title,posterpath: snapshot[index].poster_path,backpath: snapshot[index].backdrop_path,overview: snapshot[index].overview,release: snapshot[index].release_date,votecount: snapshot[index].vote_count,voteavg: snapshot[index].vote_average))),
                   child:CachedNetworkImage(
                      filterQuality: FilterQuality.high,
                      fadeInCurve: Curves.bounceIn,
                      fit: BoxFit.cover,
                      imageUrl: "https://image.tmdb.org/t/p/w500${snapshot[index].poster_path}"),
                 ),
            ),
                  ),
                ),
              );
            }),
            
        ),
        
     
      ],
    );
  }
}
