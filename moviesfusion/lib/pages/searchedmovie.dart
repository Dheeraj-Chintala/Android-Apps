import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviesfusion/pages/infopage.dart';
import 'package:moviesfusion/pages/movie.dart';
class Searchedmovie extends StatefulWidget {
   Searchedmovie({super.key,
  required this.snapshot});
final List<Movie> snapshot;
  @override
  State<Searchedmovie> createState() => _SearchedmovieState();
}

class _SearchedmovieState extends State<Searchedmovie> {
  @override
  Widget build(BuildContext context) {
    return 
 GridView.builder(
          physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,childAspectRatio: 0.7),
      
                  itemCount: widget.snapshot.length,
                  
                   itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                      height: 250,
                      // width: 150,
                   child: ClipRRect(
      
                    borderRadius: BorderRadius.circular(10),
                     child: GestureDetector(
                       onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context)=>Infopage(title:widget.snapshot[index].title,posterpath: widget.snapshot[index].poster_path,backpath: widget.snapshot[index].backdrop_path,overview: widget.snapshot[index].overview,release: widget.snapshot[index].release_date,votecount: widget.snapshot[index].vote_count,voteavg: widget.snapshot[index].vote_average))),
                       child:CachedNetworkImage(
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover,
                          imageUrl: "https://image.tmdb.org/t/p/w500${widget.snapshot[index].poster_path}",
                          
                          errorWidget: (context, url, error) {
                            return Container();
                          },),
                     ),
                   ),
              ),
                    );
                   });
  }
}




//  GridView.builder(
//           physics: AlwaysScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,childAspectRatio: 0.7),
      
//                   itemCount: widget.snapshot.length,
                  
//                    itemBuilder: (context,index){
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: SizedBox(
//                       height: 250,
//                       // width: 150,
//                    child: ClipRRect(
      
//                     borderRadius: BorderRadius.circular(10),
//                      child: GestureDetector(
//                        onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context)=>Infopage(title:widget.snapshot[index].title,posterpath: widget.snapshot[index].poster_path,backpath: widget.snapshot[index].backdrop_path,overview: widget.snapshot[index].overview,release: widget.snapshot[index].release_date,votecount: widget.snapshot[index].vote_count,voteavg: widget.snapshot[index].vote_average))),
//                        child:CachedNetworkImage(
//                           filterQuality: FilterQuality.high,
//                           fit: BoxFit.cover,
//                           imageUrl: "https://image.tmdb.org/t/p/w500${widget.snapshot[index].poster_path}",
                          
//                           errorWidget: (context, url, error) {
//                             return Container();
//                           },),
//                      ),
//                    ),
//               ),
//                     );
//                    }),




// SliverGrid(
//       delegate: SliverChildBuilderDelegate(
// (BuildContext context,int index){
//   return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: SizedBox(
//                       height: 250,
//                       // width: 150,
//                    child: ClipRRect(
      
//                     borderRadius: BorderRadius.circular(10),
//                      child: GestureDetector(
//                        onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context)=>Infopage(title:widget.snapshot[index].title,posterpath: widget.snapshot[index].poster_path,backpath: widget.snapshot[index].backdrop_path,overview: widget.snapshot[index].overview,release: widget.snapshot[index].release_date,votecount: widget.snapshot[index].vote_count,voteavg: widget.snapshot[index].vote_average))),
//                        child:CachedNetworkImage(
//                           filterQuality: FilterQuality.high,
//                           fit: BoxFit.cover,
//                           imageUrl: "https://image.tmdb.org/t/p/w500${widget.snapshot[index].poster_path}",
                          
//                           errorWidget: (context, url, error) {
//                             return Container();
//                           },),
//                      ),
//                    ),
//               ),
//                     );
// }
//     ), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//       childAspectRatio: 0.7,
//       crossAxisCount: 3));