import 'package:flutter/material.dart';
class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
 List settings=["General"," User Interface","Account center","Contact","Subscription",];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: const Color.fromARGB(255, 32, 31, 31),

     body: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
      children: [
         Container(
            height: 60,
      
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0,0,20),
              child: Text("Account",style: TextStyle(color: Colors.white70,fontSize: 25),),
            )),

          
            ListView.builder(

                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: settings.length,
                itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 60,
                        color: const Color.fromARGB(255, 44, 42, 42),
                        child: GestureDetector(
                          onTap: (){
                            showDialog(context: context, builder: (BuildContext context){
                             return AlertDialog(

                              shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                              ),
                              backgroundColor: const Color.fromARGB(255, 52, 52, 52),
                              title: Text("${settings[index]} Feature hasn't Added yet!",style: TextStyle(color: Colors.white70),),
                             );
                             
                            });
                          },
                          child: ListTile(
                            title: Text(settings[index],style:TextStyle(color: Colors.white),),
                            trailing: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_right_rounded,size: 30,color: Colors.white,)),
                          ),
                        ),
                      ),
                    ),
                  );
              
                }),
            
      ],
     ),
        )
      ],
     ),
    );
  }
}