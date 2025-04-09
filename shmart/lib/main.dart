

import 'package:flutter/material.dart';


import 'carousel.dart';
import 'sneakers.dart';
import 'loafers.dart';
import 'slides.dart';

void main(){
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
   
    );
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   List <String> coverimages=[  "assets/cone.jpg","assets/ctwo.jpg","assets/cthree.jpg","assets/cfour.jpg","assets/cfive.jpg","assets/csix.jpg","assets/cseven.jpg",];
   List <String> sneakers=[  "assets/sneakone.jpg","assets/sneaktwo.jpg","assets/sneakthree.jpg","assets/sneakfour.jpg","assets/sneakfive.jpg","assets/sneaksix.jpg","assets/sneakseven.jpg","assets/sneakeight.jpg",];
   List <String> sneaknames=["The Eighties","Preppy Kicks","Ease Walks","Rockerrs","Wanderers","City Strides","The Derbies","Embracers"];
   List <String> sneakprice=["₹1,499","₹1,999","₹1,699","₹1,299","₹1,099","₹1,699","₹2,099","₹2,199"];
   List <String> sneakoprice=[ "₹2,599","₹3,499","₹2,099","₹2,099","₹3,599","₹3,599","₹4,699","₹3,599",];
   List <String> oximages=[  "assets/oxone.jpg","assets/oxtwo.jpg","assets/oxthree.jpg","assets/oxfour.jpg","assets/oxfive.jpg","assets/oxsix.jpg"];
   List <String> oxnames=["Block heel Loafers","Oxford knits","Crossover Brogues","Charmers","Luxe Brouges","Dappers"];
   List <String> oxprice=["₹2,499","₹1,999","₹1,699","₹2,699","₹2,099","₹2,199"];
   List <String> oxoprice=["₹3,699","₹2,599","₹2,299","₹3,599","₹3,599","₹3,699"];
   List <String> slimages=[  "assets/slone.jpg","assets/sltwo.jpg","assets/slthree.jpg","assets/slfour.jpg","assets/slfive.jpg","assets/slsix.jpg"];
  List <String> slnames=["Blocks","charmers","Vanders","Foot bed","Brouges","Crossover"];
  List <String> slprice=["₹499","₹999","₹699","₹699","₹899","₹699"];
  List <String> sloprice=["₹1,099","₹1,599","₹1,499","₹1,299","₹1,399","₹1,499"];
  List <String> cartname=[];
  List <String> cartprice=[];

  Future cartitems(BuildContext context){
    return showModalBottomSheet(context: context, builder: (context){
      return Container(

        decoration: BoxDecoration(
          color: Color.fromARGB(255, 31, 31, 31),
          borderRadius: BorderRadius.only( topLeft: Radius.circular(20), topRight: Radius.circular(20))
        ),
        height: 700,
        width: double.maxFinite,
        child: Column(
          
          children: [
          
          
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10,0,0),
              child: Container(
               
                child: Text("M Y  C A R T",style: TextStyle(fontSize: 20,color: Colors.white),),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
             child:   Text("Total Items:${cartname.length}",style: TextStyle(color: Colors.white),),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              height: 340,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: cartname.length,
                itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 70,
                      color: Color.fromARGB(255, 232, 232, 232),
                      child: ListTile(
                        title: Text(cartname[index]),
                         subtitle: Text(cartprice[index]),
                        trailing: IconButton(onPressed: (){
                          setState(() {
                           cartname.removeAt(index); 
                           cartprice.removeAt(index); 
                          });
                          
                           Navigator.pop(context);
                          cartitems(context);
                      
                           
                        }, icon: Icon(Icons.delete)),
                      )),
                  ),
                );
              }),
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
            
             width: double.maxFinite,
              child:ElevatedButton(
                style:ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 86, 86, 86),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
                onPressed: (){
                 if (cartname.length==0){
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                     shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                
                   actions: [
                    
                     Container(
                      child: Image.asset("assets/emptycart.png"),
                     ),
                     Container(
                      child:Text("E M P T Y  C A R T")
                     )
                   ],
                    );
                  });
                 }
   else{

                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                     shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                
                   actions: [
                    Container(
                      height: 20,
                    ),
                     Container(
                      child: Image.asset("assets/confirmed.png"),
                     ),
                   ],
                    );
                  });
                  cartname.clear();
                  cartprice.clear();
            
                  }
                }, child: Text("CHECKOUT",style: TextStyle(fontSize: 20),))),
          )
        ],),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
     
      body: CustomScrollView(
        slivers: [
          
          SliverAppBar(
            leading: IconButton(onPressed: (){

              showDialog(context: context, builder: (context){

              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                title: Text("sh(shoe)mart App Created By"),
                content: Text("D H E E R A J"),
                actions: [
                  Container(
                    child: Image.asset("assets/creator.png"),
                  )
                ],
              );
              });
            }, icon:Icon(Icons.menu,color: Color.fromARGB(255, 225, 225, 225),)),
            backgroundColor: Colors.black,
            centerTitle: true,
            title: Text("S H M A R T",style: TextStyle(color: Colors.white),),
            actions: [
          IconButton(onPressed: (){
            cartitems(context);

           
          }, icon: Icon(Icons.shopping_cart,color: Color.fromARGB(255, 225, 225, 225),),)
         ],
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 carousel(coverimages: coverimages),
              Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 100, 0, 0),
              child: Text("S N E A K E R S",style: TextStyle(color: Color.fromARGB(255, 197, 197, 197),fontSize: 30)),
            ),
           ),


   allsneakers(sneakers: sneakers, sneaknames: sneaknames, sneakprice: sneakprice, sneakoprice: sneakoprice,cartname: cartname,cartprice: cartprice),


     Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 100, 0, 0),
              child: Text("L O A F E R S",style: TextStyle(color: Color.fromARGB(255, 198, 198, 198),fontSize: 30)),
            ),
           ),



              loafers(oximages: oximages, oxnames: oxnames, oxprice: oxprice, oxoprice: oxoprice,cartname: cartname,cartprice: cartprice),

     
Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 100, 0, 0),
              child: Text("S L I D E S",style: TextStyle(color: const Color.fromARGB(255, 196, 196, 196),fontSize: 30)),
            ),
           ),



slides(slimages: slimages, slnames: slnames, slprice: slprice, sloprice: sloprice,cartname: cartname,cartprice: cartprice),



              ],
            ),
          )
        ],
      ),
    );
  }
}







