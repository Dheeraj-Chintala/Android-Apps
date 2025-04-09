import 'package:flutter/material.dart';
class loafers extends StatelessWidget {
  const loafers({
    super.key,
    required this.oximages,
    required this.oxnames,
    required this.oxprice,
    required this.oxoprice,
   required this.cartname,
    required this.cartprice,
  });

  final List<String> oximages;
  final List<String> oxnames;
  final List<String> oxprice;
  final List<String> oxoprice;
  final List<String> cartname;
  final List<String> cartprice;
  

void addtocart(name,price){

 cartname.add(name);
cartprice.add(price);

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
             children: List.generate(oximages.length,
             
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
                          
                          child: Image.asset(oximages[index],fit: BoxFit.contain,)),
                          Expanded(flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(
                                
                                oxnames[index]
                                ,style: TextStyle(fontSize: 20),
                                ),
                            )),
                            Expanded(flex: 1,
                            child: Row(children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(oxprice[index],style: TextStyle(fontSize: 18),),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(oxoprice[index],
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
                              title: Text("${oxnames[index]} added to Cart"),
                              content: Text("S U C C E S S F U L L Y"),
                              actions: [
                                Container(
                                  child: Image.asset("assets/itemadded.png"),
                                )
                              ],
                            );
                          });
                          
                        
                            addtocart(oxnames[index],oxprice[index]);
                      

                          

                            }, icon: Icon(Icons.shopping_bag,size: 40,)),
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