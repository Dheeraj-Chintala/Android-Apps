import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dependency_injection.dart';

Future<void> main()async{
  runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),));
    DependencyInjection.init();
    
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isvisible=false;
  TextEditingController inp=TextEditingController();
  List<dynamic> mintiles=["Humidity","Wind Speed","Pressure","Min Temp","Max temp","Feels Like"];
  List<dynamic> metrics=["%","m/s","hPa","°C","°C","°C"];

  dynamic temperature=0;
  dynamic windspeed= 0;
  dynamic humidity=0;
  dynamic feelslike=0;
  dynamic tempmin=0;
  dynamic tempmax=0;
  dynamic pressure=0;
  dynamic city="";
 dynamic descript="";

  List<IconData> iconspack=[Icons.water_drop_outlined,Icons.wind_power_outlined,Icons.gas_meter_outlined,Icons.sunny_snowing,Icons.wb_sunny_outlined,Icons.air_outlined];
  List <dynamic> tiledata=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updatetiledata();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      
      appBar: AppBar(
        title: Text("${city}".toUpperCase(),style: TextStyle(fontSize: 30),),
         backgroundColor: Colors.grey,
        toolbarHeight: 100,
        actions: [
          IconButton(onPressed: (){
            setState(() {
              if (isvisible==false){
                isvisible=true;
              }
              else{
                isvisible=false;
              }
            });
          }, icon: Icon(Icons.search)),
        ],
      ),
      backgroundColor: Colors.grey,
      body: Column(
        children: [
          Visibility(
          visible: isvisible,
            child: Container(
              child: TextField(
                controller: inp,
                decoration:InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Container(
                    height: 35,
                    child:ElevatedButton(onPressed: (){
                      setState(() {
                        city=inp.text;
                     
                      });
                      fetchweather(city);
                      setState(() {
                        isvisible=false;
                      });
                    }, child: Text("Search"),
                    style:ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                      backgroundColor: Color.fromARGB(156, 75, 70, 70),
                      foregroundColor: const Color.fromARGB(220, 255, 255, 255),
                    ),
                    ),
                  ),
                ),
                
              ),
            ),
          ),
         Container(
          child: Center(child: Text("${temperature.toString()}°C",style: TextStyle(fontSize: 90),)),
         ),
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Container(
            child: Center(child: Text("${descript}".toUpperCase(),style: TextStyle(fontSize: 25),)),
           ),
         ),
     
      Expanded(

        child: GridView.count(crossAxisCount: 3,
        children:List.generate(6, (index){
         return Padding(
           padding: const EdgeInsets.all(10.0),
           child: SizedBox(
            child:Container(
             child: Column(
                children:[
                  Expanded(
   
                  flex: 2,
                     child: Center(child: Icon(iconspack[index],size: 30,)),
              
                  ),
                  Expanded(
     
           
                    child: Center(child: Text("${mintiles[index]}",style: TextStyle(fontSize: 15),)),
                   
                  ),
                  Expanded(
                    flex: 3,
                    child: Center(child: Text( "${tiledata[index].toString()} ${metrics[index]}",style: TextStyle(fontSize: 25),)),
                   
                  ),
                ],
               ),
             decoration: BoxDecoration(
             color: Color.fromARGB(166, 75, 70, 70),
              borderRadius: BorderRadius.circular(10)
             ),
            ),
           ),
         );
        },),
        ),
      ),

Container(
  alignment: Alignment(1, -1),
  child: Padding(
    padding: const EdgeInsets.all(15.0),
    child: IconButton(onPressed: (){
                 liveloc();
            }, 
        
            icon: Icon(Icons.location_pin,size: 60,),),
  ),
),

        ],
      )
    );
  }
void liveloc()async{
  LocationPermission permission=await Geolocator.checkPermission();
  if(permission==LocationPermission.denied){
    permission=await Geolocator.requestPermission();
  }
  Position position=await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high);
    List<Placemark>Placemarks=await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      city=Placemarks[0].locality;
    });
   fetchweather( city);

    print(city);
    
}
    void fetchweather( String search) async{
  // const search="dubai";
  const key="02c2df9d99fa8add8255fc9f0a5a8313";
  const base="https://api.openweathermap.org/data/2.5/";
  print("fetching started");
  var url="${base}weather?q=${search}&units=metric&APPID=${key}";
  final uri=Uri.parse(url);
  final response=await http.get(uri);
  if (response.statusCode==200){
  final body=response.body;
  final json=jsonDecode(body);
  // as Map<String, dynamic>
  setState(() {
    temperature=json['main']['temp'];
    windspeed=json['wind']['speed'];
    humidity=json['main']['humidity'];
    feelslike=json['main']['feels_like'];
    tempmin=json['main']['temp_min'];
    tempmax=json['main']['temp_max'];
    pressure=json['main']['pressure'];
    descript=json['weather'][0]['description'];
    updatetiledata();

  });

  print("DOne");
  }
  else{
    print("ENTER MAIN CITY");
    setState(() {
      city="Enter only main city";
      inp.text="Enter main city";
    });
  }
 
}


void updatetiledata(){
 setState(() {
   tiledata=[humidity,windspeed,pressure,tempmin,tempmax,feelslike];
 });
}

}
