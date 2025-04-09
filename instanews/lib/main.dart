import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'post1.dart';
import 'package:url_launcher/link.dart';
void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   List categories=["business","entertainment","general","health","science","sports","technology"];
  String categ="general";
  Future<Map<String, dynamic>> fetchnews(String category) async {
    final apiKey = "bc9acc14582d4ffea22282548d1faed1";
  
   
    final url="https://newsapi.org/v2/top-headlines?country=us&category=${category}&apiKey=${apiKey}";
    final fetch = Uri.parse(url);

    try {
      final response = await http.get(fetch);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data; 
      } else {
        throw Exception("Failed to fetch data");
      }
    } catch (e) {
      print("Error: $e");
      return {}; 
    }
  }

  final control = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 35, 34, 34),
      extendBodyBehindAppBar: true,
     appBar: AppBar(
      backgroundColor: Colors.transparent,
      
    
      elevation: 0,
     foregroundColor: Colors.white,
     ),
      drawer: Drawer(
        backgroundColor:const Color.fromARGB(255, 28, 28, 30),
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
Container(
  height: 70,
),
 Align(
  alignment: Alignment.centerLeft,
  
    child: Padding(
      padding: const EdgeInsets.fromLTRB(15,0,0,0),
      child: Text("News Categories",style: TextStyle(color: Colors.white70,fontSize: 15),),
    ),
  
 ),


            Container(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context,index){
                  return TextButton(
                    onPressed: (){
                     setState(() {
                       categ=categories[index];
                     });
                     Navigator.pop(context);
                     }, child: Text(categories[index],style: TextStyle(color:Colors.white60),));
                }
                ),
            )
          ],
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchnews(categ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(

              child: CircularProgressIndicator(
                backgroundColor: Color.fromARGB(255, 35, 34, 34),
                color: Colors.white70,
                
              ), 
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'), 
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
           
            return PageView.builder(
              physics: PageScrollPhysics(),
              itemCount: snapshot.data!['articles'].length, 
              itemBuilder: (context, index) {
                return Post1(
                  index: index + 1, 
                  total: snapshot.data!.length,  
                  data: snapshot.data!, 
                );
              },
              scrollDirection: Axis.vertical,
              controller: control,
            );
          } else {
            return Center(
              child: Text("No Data Available"),  // Fallback if no data
            );
          }
        },
      ),
    );
  }
}
