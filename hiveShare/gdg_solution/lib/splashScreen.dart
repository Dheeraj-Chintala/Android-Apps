import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gdg_solution/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  late VideoPlayerController vidcontroller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vidcontroller = VideoPlayerController.asset('assets/sea.mp4')
      ..initialize().then((_) {
        setState(() {
          vidcontroller.play();
          vidcontroller.setLooping(true);
          vidcontroller.setVolume(0.0);
        });
      });
  }
  @override
  void dispose(){
    super.dispose();
    vidcontroller.dispose();
  }
  List greetText = [
    "Donate Clothes and Give your pre-loved outfits a new home",
    "Share Books and Let knowledge travel beyond shelves",
    "Pass On Leftover Food and Help reduce waste and feed those in need",
    "Together, we create a world where nothing goes to waste and kindness connects us all."
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()));
        },
        child: Icon(Icons.arrow_forward_ios),
      ),
      body: Stack(fit: StackFit.expand, children: [
        vidcontroller.value.isInitialized
            ? AspectRatio(
                aspectRatio: vidcontroller.value.aspectRatio,
                child: VideoPlayer(vidcontroller),
              )
            : Container(color: Colors.black),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 70,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/gdlogo.png",
                  height: 50,
                ),
                Text("HiveShare", style: GoogleFonts.offside(fontSize: 50))
              ],
            ),
            Divider(),
            SizedBox(
              height: 70,
            ),
            CarouselSlider(
                items: greetText.map((greet) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: const Color.fromARGB(120, 20, 20, 20),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              greet,
                              textAlign: TextAlign.center
                              ,
                              style: GoogleFonts.oswald(fontSize: 30),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 1,
                )),
                Spacer(),
            Container(
              width: double.infinity,
              color: const Color.fromARGB(112, 0, 0, 0),
              child: Text(
                "Start  Sharing  Now!",
                style: GoogleFonts.imperialScript(
                    fontSize: 50,fontWeight: FontWeight.bold ),
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
          ],
        ),
      ]),
    );
  }
}
