import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
class Infopage extends StatefulWidget {
  const Infopage({super.key,
  required this.title,
  required this.posterpath,
  required this.backpath,
  required this.overview,
  required this.release,
 
  required this.voteavg,
  required this.votecount,
  });
  
  
  final dynamic title;
  
  final dynamic posterpath;
  
  final dynamic votecount;
  
  final dynamic release;
  
  
  final dynamic voteavg;
  
  final dynamic overview;
  
  final dynamic backpath;
  @override
  State<Infopage> createState() => _InfopageState();
}

class _InfopageState extends State<Infopage> {
  double rating=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  ratingcount();
  }
  void ratingcount(){
    final rate=widget.voteavg/10;
    setState(() {
      rating=rate;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: const Color.fromARGB(255, 32, 31, 31),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
             foregroundColor: Colors.white70,
             backgroundColor: const Color.fromARGB(255, 32, 31, 31),
             expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
      titlePadding: EdgeInsets.all(10),
              title: Row(
                children: [
                  ClipRRect(
                    borderRadius:BorderRadius.circular(5),
                    child: SizedBox(
                                    height: 100,
                                    child: CachedNetworkImage(
                    imageUrl: "https://image.tmdb.org/t/p/w500${widget.posterpath}"),
                                  ),
                  ),Padding(
                    padding: const EdgeInsets.fromLTRB(5, 50, 0, 0),
                    child: Container(
                      width: 180,
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        widget.title,style: TextStyle(fontSize: 15,color: Colors.white70),),
                    ),
                  )
                ],
              ),
              background:Stack(
                children: [
                  Container(
                 color: const Color.fromARGB(255, 32, 31, 31),
                height: 300,
                child: CachedNetworkImage(
                  
                  fit: BoxFit.cover,
                  
                  imageUrl: "https://image.tmdb.org/t/p/w500${widget.backpath}"),
              ),
              Container(
               
                decoration:BoxDecoration(
                 gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [const Color.fromARGB(0, 0, 0, 0),const Color.fromARGB(218, 0, 0, 0)])
                  ),
              )
                ],
              ),

            ),
          ),

          SliverToBoxAdapter(
  
          child: Column(
            
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20,0,0),
                child: Text("Release Date",style: TextStyle(color: Colors.white,fontSize: 15),),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0,0),
                child: Text(widget.release.toString(),style: TextStyle(color: Colors.white70),),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20,0,0),
                child: Text("Overview",style: TextStyle(color: Colors.white,fontSize: 15),),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0,0),
                child: Text(widget.overview,style: TextStyle(color: Colors.white70),),
              ),
               Padding(
                 padding: const EdgeInsets.fromLTRB(10, 20,0,0),
                 child: Text("Max Votes",style: TextStyle(color: Colors.white,fontSize: 15),),
               ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0,0),
                  child: Text(widget.votecount.toString(),style: TextStyle(color: Colors.white70),),
                ),
              Padding(
                 padding: const EdgeInsets.fromLTRB(0, 20,50,10),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text("Rating",style: TextStyle(color: Colors.white,fontSize: 15),)),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0,0, 20, 0),
                  child: SizedBox(
                              
                  child: CircularPercentIndicator(
                    backgroundColor: const Color.fromARGB(255, 32, 31, 31),
                    animation: true,
                    progressColor: const Color.fromARGB(255, 7, 255, 23),
                    radius: 40,
                    percent: rating,
                    startAngle: 180,
                    animationDuration: 500,
                    lineWidth: 15,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Text(widget.voteavg.toString(),style: TextStyle(color: Colors.white70),),
                    ),
                  
                              ),
                ),
              ),
            ],
           
          ), 
          )


        ],
      ),
    );
  }
}

