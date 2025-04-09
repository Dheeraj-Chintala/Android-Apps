
import 'dart:convert';
import 'connectivityservice.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
void main(){runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),));
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
final ConnectivityService _connectivityService = ConnectivityService();
String mealtitle="";
String mealthumb="";
String mealtype="";
String mealinstructions="";
List ingred1=[];

Future<void> fetchData() async {
  final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));

  if (response.statusCode == 200) {

     var data = jsonDecode(response.body);


    setState(() {

      mealtitle=data['meals'][0]['strMeal'];
      mealthumb=data['meals'][0]['strMealThumb'];
      mealtype=data['meals'][0]['strCategory'];
      mealinstructions=data['meals'][0]['strInstructions'];
      ingred1.add(data['meals'][0]['strIngredient1']);
      ingred1.add(data['meals'][0]['strIngredient2']);
      ingred1.add(data['meals'][0]['strIngredient3']);
      ingred1.add(data['meals'][0]['strIngredient4']);
      ingred1.add(data['meals'][0]['strIngredient5']);
    });

  } else {
   
    throw Exception('Failed to load data');
  }
}


@override
void initState() {
  super.initState();
   _connectivityService.checkConnectivity(context);
  fetchData();
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: const Color.fromARGB(105, 0, 0, 0),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
          actions:<Widget> [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromARGB(190, 0, 0, 0),
              ),
              child: IconButton(onPressed: fetchData, icon: Icon(Icons.refresh_rounded,color: const Color.fromARGB(255, 255, 255, 255)))),
          ],
          expandedHeight: 350,
           flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.all(20),
            title: Text(mealtitle,style: TextStyle(color: Colors.white,),),
            background: Container(

              child: Stack(
                children: [
                  Container(
                    height: 400,
                    child: LottieBuilder.asset('assets/cooking.json')),
                    
                   Container(
                  height: 400,
                    child: CachedNetworkImage(
                      
                      imageUrl: mealthumb,
                      height: double.maxFinite,
                      width: double.maxFinite,
                      fit:BoxFit.cover,
                      key: UniqueKey(),
                      placeholder: (context, url) => Text(" "),
                      ),
                   ),
                   Container(

                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors:[ const Color.fromARGB(0, 0, 0, 0),Color.fromARGB(174, 0, 0, 0)]),
                    ),
                   ),
                ],
              ),
       
            ),
           ),
          ),
   SliverToBoxAdapter(
    child: Container(
   child: Padding(
     padding: const EdgeInsets.all(15.0),
     child: Text("I N G R E D I E N T S",style: TextStyle(color: Colors.white,fontSize: 18)),
   ),
      height: 50,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 37, 30, 30),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      ),
    ),
   ),
   SliverList.builder(
  
  itemCount: ingred1.length,
  itemBuilder: (BuildContext context,index){
     return Container(
      color:  Color.fromARGB(255, 48, 41, 41),
       padding: const EdgeInsets.fromLTRB(15 ,0, 0, 0 ),
       child: Text(ingred1[index],style: TextStyle(color: const Color.fromARGB(170, 255, 255, 255))),
     );
}),
      SliverToBoxAdapter(

        child:Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              height: 50,
                decoration: BoxDecoration(
        color:  Color.fromARGB(255, 37, 30, 30),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20)
        )
      ),
              child:Padding(
                padding: const EdgeInsets.all(15),
                child: Text("H O W   T O   C O O K ?",style: TextStyle(color: Colors.white,fontSize: 18)),
              ),
            ),
            Container(
              color:  Color.fromARGB(255, 48, 41, 41),
            padding: const EdgeInsets.all(15.0),
            child: Text(mealinstructions,style: TextStyle(color: const Color.fromARGB(170, 255, 255, 255)),),
          ),
          ],
        ),
      ) ,   
          
       
       
        SliverToBoxAdapter(
          child: FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 37, 30, 30),
             child: Text('F I N D    A N O T H E R    R E C I P E',style: TextStyle(color: Colors.white,fontSize: 18)), onPressed: fetchData)),
        ],
      ),
    );
  }
}

