import 'package:flutter/material.dart';
void main(){
  runApp(MaterialApp(home: MyApp(),));
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   TextEditingController inserteddata=TextEditingController();
  var textins="enter text";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Q R   F O R G E ",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.grey[700],
      ),
       backgroundColor: Colors.grey[600],
      body: Center(
        child: Column(
          children: [
        
           Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 250,
                width: 250,
           
              child: Image.asset('assets/loading.png'),
              ),
               Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                height: 300,
            
                child: Image.network('https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=${textins}'),
              ),
            ),
            ],
           ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 400,
                child: TextField(
                  
                  controller: inserteddata,
                  decoration: InputDecoration(
                    labelText: "Enter ",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 74, 74, 74)),
                    ),
                    suffixIcon:SizedBox(
                      height: 50,        
                      child: ElevatedButton(
                         onPressed: (){
                           setState(() {
                           textins=inserteddata.text;
                            if (textins==""){
                              textins="Enter the text Bitch";
                            }
                          });
                          
                        },
                      
                      child: Text("Generate",style: TextStyle(fontSize: 15),),
                      style:ElevatedButton.styleFrom(
                        
                        backgroundColor: Colors.grey[800],
                        foregroundColor: Colors.white,
                        
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      )
                      ,),
                                        
                    ),
                ),
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}