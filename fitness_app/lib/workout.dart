import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Workout extends StatefulWidget {
  final List workoutdata;

  Workout({super.key, required this.workoutdata});

  @override
  State<Workout> createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  final supabase = Supabase.instance.client;
  final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  num caloriesSpent = 0;
  int nofexercise = 0;
  int seconds = 300;
  bool running = false;
  Timer? timer;
  void timerfn() {
    if (running) {
      timer?.cancel();
    } else {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (seconds > 0) {
          setState(() {
            seconds--;
          });
        } else {
          timer.cancel();
        }
      });
    }
    setState(() {
      running = !running;
    });
  }

  String formattime(int seconds) {
    int minutes = seconds ~/ 60;
    int secondsleft = seconds % 60;
    return '${minutes} : ${secondsleft}';
  }

  final PageController pageController = PageController(initialPage: 0);
  saveData() async {
    try {
      final mail = supabase.auth.currentUser!.email!;
      final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final response = await supabase
          .from('progress')
          .select()
          .eq('email', mail)
          .eq('date', date);
      final fetchedData = response.single;
      print(fetchedData);
      await supabase.from('progress').upsert({
        'email': mail,
        'date': date,
        'caloriespent': fetchedData['caloriespent'] + caloriesSpent,
        'exercisesdone': fetchedData['exercisesdone'] + nofexercise,
      }, onConflict: 'email,date');
    } catch (e) {
      if (e is StateError) {
        try {
          final mail = supabase.auth.currentUser!.email!;

          await supabase.from('progress').insert({
            'email': mail,
            'date': date,
            'caloriespent': caloriesSpent,
            'exercisesdone': nofexercise,
          });
        } catch (e) {
          print(e);
        }
      } else {
        print(e);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        pageSnapping: true,
        itemCount: widget.workoutdata.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(30, 60, 30, 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: const Color.fromARGB(255, 39, 39, 39),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/exercises/${widget.workoutdata[index]['Image']}',
                      height: 300,
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                      child: Text(
                        widget.workoutdata[index]['Name of Exercise'],
                        style: GoogleFonts.bebasNeue(
                          color: const Color.fromARGB(255, 38, 255, 0),
                          fontSize: 40,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 3, 0, 0),
                      child: Text(
                        'Benefits',
                        style: GoogleFonts.ptSansNarrow(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text(
                        widget.workoutdata[index]['Benefit'],
                        style: GoogleFonts.ptSansNarrow(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Text(
                        'Target Muscle Group',
                        style: GoogleFonts.ptSansNarrow(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text(
                        widget.workoutdata[index]['Target Muscle Group'],
                        style: GoogleFonts.ptSansNarrow(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Text(
                        'Instructions',
                        style: GoogleFonts.ptSansNarrow(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text(
                        'Sets: ${widget.workoutdata[index]['Sets']} Reps: ${widget.workoutdata[index]['Reps']}',
                        style: GoogleFonts.ptSansNarrow(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    // SizedBox(height: 30,),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Text(
                        'Timer',
                        style: GoogleFonts.ptSansNarrow(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: timerfn,
                          icon: Icon(
                            running
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 50,
                            color: Color.fromARGB(206, 38, 255, 0),
                          ),
                        ),
                        Text(
                          '${formattime(seconds)}',
                          style: GoogleFonts.ptSansNarrow(
                            color: const Color.fromARGB(191, 38, 255, 0),
                            fontSize: 50,
                          ),
                        ),
                      ],
                    ),

                    Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          backgroundColor: const Color.fromARGB(
                            203,
                            38,
                            255,
                            0,
                          ),

                          onPressed: () async {
                            caloriesSpent +=
                                widget.workoutdata[index]['Sets'] *
                                widget.workoutdata[index]['caloriespm'];
                            nofexercise++;

                            timer?.cancel();
                            seconds = 300;

                            saveData();
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Icon(Icons.skip_next_rounded, size: 30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
