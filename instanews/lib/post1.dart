import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class Post1 extends StatefulWidget {
  final int index;
  final int total;
  final Map<String, dynamic> data;
  const Post1({
    super.key,
    required this.index,
    required this.total,
    required this.data,

  });
  
  @override
  State<Post1> createState() => _Post1State();
}

class _Post1State extends State<Post1> {
 @override
  Widget build(BuildContext context) {
dynamic articles = widget.data['articles'] ?? 'No title';
    return  Scaffold(
     backgroundColor: const Color.fromARGB(255, 0, 0, 0),
    
     body: Padding(
       padding: const EdgeInsets.all(10.0),
       child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
         color: Colors.transparent,
        child:Column(

          children: [
            
            Expanded(
            child: 
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
               
                fit: BoxFit.cover,
                imageUrl: articles[widget.index]['urlToImage']??"https://groups.google.com/g/digital-services-2024/c/0xO0XO8NAH0",
                placeholder: (context,url)=>Container(
                  color: const Color.fromARGB(255, 0, 0, 0),
              
                ),
                errorWidget: (context, url, error) => Container(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  
                  child:Image.asset("assets/newsplace.png",fit: BoxFit.cover,),
                ),
                ),
            )
              ),
            Expanded(
              
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                
                child: Container(
                  color: const Color.fromARGB(255, 28, 28, 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                        Expanded(
                          flex: 2,
                          child:Column(
                            children: [
                             Padding(
                              padding: const EdgeInsets.fromLTRB(10, 30,0,0),
                               child: Text(articles[widget.index]['title']?? "",style: TextStyle(fontSize: 20,color: Colors.white),),
                             ),
                             Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0,0,0),
                               child: Text("${articles[widget.index]['description']??""} ${articles[widget.index]['content']??""}",style: TextStyle(color: Colors.white60),),
                             ),
                            ],
                          ) ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0,0,0),
                          child: Text('''By ${articles[widget.index]['author']??"Unknown"}
On ${datetime(articles[widget.index]['publishedAt']??"")}
                          ''',style: TextStyle(color: Colors.white54),),
                        )
                      
                      ),
                    ],
                  ),
                ),
              ))
          ],
        ),
       ),
     ),
    );
    
  }
}
datetime(timestamp){
 



  
  
  DateTime dateTime = DateTime.parse(timestamp);

  
  String formattedDate = DateFormat('MMMM d, y').format(dateTime);

 
  return formattedDate;


}