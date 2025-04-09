import 'package:flutter/material.dart';
import 'cinetiles.dart';
import 'carousel.dart';
import 'package:moviesfusion/homepage.dart';
import 'movie.dart';
import 'package:url_launcher/link.dart';
class home extends StatelessWidget {
  home({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 60,
      
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0,0,20),
                  child: Text("MoviesFusion",style: TextStyle(color: const Color.fromARGB(223, 255, 255, 255),fontSize: 25,),),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,10),
                  child: IconButton(
                    onPressed: (){
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                         
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                          ),
                          backgroundColor:const Color.fromARGB(255, 32, 31, 31),
                          
                          content: Container(
                            height: 500,
                            child: Column(
                              
                               mainAxisAlignment: MainAxisAlignment.center,
                              
                                children: [
                                  Image.asset("assets/appcreator.png"),
                                 Container(child: Text("App Created By",style: TextStyle(color: Colors.white54),)),
                                 Text("D H E E R A J",style: TextStyle(fontSize: 20,color: Colors.white70),),
                              
                                  Row(
                                    
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Link(uri: Uri.parse("https://www.instagram.com/dheeraj_chinthala?igsh=bGU5a3I3aG41bzY="),
                                      target: LinkTarget.blank,
                                       builder: (context,FollowLink){
                                        return  SizedBox(
                                          height: 70,
                                          child: IconButton(onPressed:FollowLink, icon: Image.asset("assets/instapng.png")));
                                      }),
                                      Link(uri: Uri.parse("https://github.com/Dheeraj-Chintala"),
                                      target: LinkTarget.blank,
                                       builder: (context,FollowLink){
                                        return  SizedBox(
                                          height: 70,
                                          child: IconButton(onPressed:FollowLink, icon: Image.asset("assets/githubpng.png")));
                                      }),
                                     
                                    ],
                                  ),
                                ],
                              ),
                          ),
                          
                        );
                      });

                    }, icon: Icon(Icons.more_vert,size: 30,color: Colors.white70,)),
                )
              ],
            )),
          FutureBuilder<List<Movie>>(
            future: apidata().nowplaying(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(); 
              } else if (snapshot.hasData) {
                return carousel(snapshot: snapshot.data!); 
              } else if (snapshot.hasError) {
                print("Error: ${snapshot.error}");
                return Text("Error : ${snapshot.error}");
              } else {
                return Text("No data available");
              }
            },
          ),



          FutureBuilder<List<Movie>>(
            future: apidata().toprated(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(); 
              } else if (snapshot.hasData) {
                return cinetiles(category:"Top Rated",snapshot: snapshot.data!); 
              } else if (snapshot.hasError) {
                print("Error: ${snapshot.error}");
                return Text("Error : ${snapshot.error}");
              } else {
                return Text("No data available");
              }
            },
          ),




          FutureBuilder<List<Movie>>(
            future: apidata().popular(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(); 
              } else if (snapshot.hasData) {
                return cinetiles(category:"Popular",snapshot: snapshot.data!); 
              } else if (snapshot.hasError) {
                print("Error: ${snapshot.error}");
                return Text("Error : ${snapshot.error}");
              } else {
                return Text("No data available");
              }
            },
          ),



           
            FutureBuilder<List<Movie>>(
            future: apidata().upcoming(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(); 
              } else if (snapshot.hasData) {
                return cinetiles(category:"upcoming",snapshot: snapshot.data!); 
              } else if (snapshot.hasError) {
                print("Error: ${snapshot.error}");
                return Text("Error : ${snapshot.error}");
              } else {
                return Text("No data available");
              }
            },
          ),



          
        ],
      ),
    );
  }
}
