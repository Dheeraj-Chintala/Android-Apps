import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:moviesfusion/pages/infopage.dart';
import 'package:moviesfusion/pages/movie.dart';

class carousel extends StatefulWidget {
  carousel({
    super.key,
    required this.snapshot,
  });

  final List<Movie> snapshot;

  @override
  State<carousel> createState() => _carouselState();
}

class _carouselState extends State<carousel> {
     int titleindex=0;
  @override
  Widget build(BuildContext context) {
 
    return Column(
     
      children: [
        CarouselSlider.builder(
          
          itemCount: widget.snapshot.length, 
          itemBuilder: (context, index, page) {
           
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
        
               child: GestureDetector(
                onTap:()=> Navigator.push(context,MaterialPageRoute(builder: (context)=>Infopage(title:widget.snapshot[index].title,posterpath: widget.snapshot[index].poster_path,backpath: widget.snapshot[index].backdrop_path,overview: widget.snapshot[index].overview,release: widget.snapshot[index].release_date,votecount: widget.snapshot[index].vote_count,voteavg: widget.snapshot[index].vote_average,))),
                 child: CachedNetworkImage(
                  height: 300,
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover,
                  
                  imageUrl: "https://image.tmdb.org/t/p/w500${widget.snapshot[index].poster_path}"),
               ),
                ),
            );
          },
          options: CarouselOptions(
  
            autoPlay: true,
            height: 300,
            enlargeCenterPage: true,
            autoPlayAnimationDuration: Duration(seconds: 1),
            viewportFraction: 0.55,
            onPageChanged: (index,reason){
              setState(() {
                titleindex=index;
              });
            }
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0,20,0,0),
          child: Text(widget.snapshot[titleindex].title,style: TextStyle(color: Colors.white,fontSize: 25),),
        )
      ],
    );
  }
}
