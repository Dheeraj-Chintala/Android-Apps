
import 'package:flutter/material.dart';

class allsneakers extends StatefulWidget {
  const allsneakers({
    super.key,
    required this.sneakers,
    required this.sneaknames,
    required this.sneakprice,
    required this.sneakoprice,
    required this.cartname,
     required this.cartprice,
  });

  final List<String> sneakers;
  final List<String> sneaknames;
  final List<String> sneakprice;
  final List<String> sneakoprice;
  final List<String> cartname;
  final List<String> cartprice;

  @override
  State<allsneakers> createState() => _allsneakersState();
}

class _allsneakersState extends State<allsneakers> {


void addtocart(name,price){

  widget.cartname.add(name);
  widget.cartprice.add(price);

    // additem(name,price);

}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(
       physics: NeverScrollableScrollPhysics(),
           childAspectRatio: 1/1.2,
           crossAxisCount: 2,
     
          mainAxisSpacing: 30,
           shrinkWrap: true,
          children: List.generate(widget.sneakers.length,
          
           (index){
             return Padding(
               padding: const EdgeInsets.fromLTRB(10,0,10,10),
               child: ClipRRect(
                 borderRadius: BorderRadius.circular(10),
                 child: Container(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Expanded(
                       flex: 4,
                       
                       child: Image.asset(widget.sneakers[index],fit: BoxFit.contain,)),
                       Expanded(flex: 1,
                         child: Padding(
                           padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                           child: Text(
                             
                             widget.sneaknames[index]
                             ,style: TextStyle(fontSize: 20),
                             ),
                         )),
                         Expanded(flex: 1,
                         child: Row(children: [
                           Padding(
                             padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                             child: Text(widget.sneakprice[index],style: TextStyle(fontSize: 18),),
                           ),
                           Padding(
                             padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                             child: Text(widget.sneakoprice[index],
                             style: TextStyle(
                               decoration: TextDecoration.lineThrough,
                             ),
                             ),
                           )
                           ],)),
                      
    
                       Padding(
                         padding: const EdgeInsets.fromLTRB(140, 0,0,0),
                         child: IconButton(onPressed: (){
                           

                          showDialog(context: context, builder: (context){
                            
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                              title: Text("${widget.sneaknames[index]} added to Cart"),
                              content: Text("S U C C E S S F U L L Y"),
                              actions: [
                                Container(
                                  child: Image.asset("assets/itemadded.png"),
                                )
                              ],
                            );
                          });
                          
                        
                            addtocart(widget.sneaknames[index],widget.sneakprice[index]);
                      

                          

                          

                         }, icon:Icon(Icons.shopping_bag,size: 40,)),
                       ),
                   ],
                 ),
                   color: Color(0xFFC3C2C0),
                 ),
               ),
             );
           }
           
           ),
          ),
    );
  }
}

