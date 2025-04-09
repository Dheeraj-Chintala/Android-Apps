import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
class carousel extends StatelessWidget {
  const carousel({
    super.key,
    required this.coverimages,
  });

  final List<String> coverimages;

  @override
  Widget build(BuildContext context) {
    return Container(
     child: CarouselSlider.builder(
       itemCount: coverimages.length,
       options: CarouselOptions(
          height: 330,
          autoPlay: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          autoPlayAnimationDuration: Duration(seconds: 1),
          viewportFraction:0.55,
          enlargeCenterPage: true,
          
       ), 
       itemBuilder: (context,index,page){
         return Padding(
           padding: const EdgeInsets.all(8.0),
           child: ClipRRect(
             borderRadius: BorderRadius.circular(10),
             child: Container(
               width: 220,
               height: 200,
               color: const Color.fromARGB(255, 0, 0, 0),
               child: Image.asset("${coverimages[index]}",fit: BoxFit.cover,),
               
             ),
           ),
         );
       }, 
       ),
    );
  }
}