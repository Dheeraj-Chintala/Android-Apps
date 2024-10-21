import 'package:flutter/material.dart';
class slides extends StatelessWidget {
  const slides({
    super.key,
    required this.slimages,
    required this.slnames,
    required this.slprice,
    required this.sloprice,
      required this.cartname,
    required this.cartprice,
  });

  final List<String> slimages;
  final List<String> slnames;
  final List<String> slprice;
  final List<String> sloprice;
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
             children: List.generate(slimages.length,
             
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
                          
                          child: Image.asset(slimages[index],fit: BoxFit.contain,)),
                          Expanded(flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(
                                
                                slnames[index]
                                ,style: TextStyle(fontSize: 20),
                                ),
                            )),
                            Expanded(flex: 1,
                            child: Row(children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(slprice[index],style: TextStyle(fontSize: 18),),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(sloprice[index],
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
                              title: Text("${slnames[index]} added to Cart"),
                              content: Text("S U C C E S S F U L L Y"),
                              actions: [
                                Container(
                                  child: Image.asset("assets/itemadded.png"),
                                )
                              ],
                            );
                          });
                          
                        
                            addtocart(slnames[index] ,slprice[index]);
                      

                          

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