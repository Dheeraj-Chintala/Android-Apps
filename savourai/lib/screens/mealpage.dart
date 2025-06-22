import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savourai/models/meal.dart';
import 'package:savourai/screens/about.dart';
import 'package:url_launcher/url_launcher.dart';

class MealPage extends StatefulWidget {
  final Meal meal;
  final Color backgroundColor;
  const MealPage({Key? key, required this.meal, required this.backgroundColor})
    : super(key: key);

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meal = widget.meal;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 25, 15, 20),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: widget.backgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: meal.thumbnail,
                        height: screenHeight * 0.4,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          return Icon(Icons.broken_image, size: 50);
                        },
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        height: screenHeight * 0.4,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(0, 0, 0, 0),
                              Color.fromARGB(170, 0, 0, 0),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                overflow: TextOverflow.fade,
                                meal.name,
                                style: GoogleFonts.ptSansNarrow(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                ),
                              ).animate().fade(duration: Duration(seconds: 1)),
                              Text(
                                "● ${meal.category ?? ''} ● ${meal.area ?? ''}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, size: 20),
                          onSelected: (value) {
                            // Action handler
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AboutScreen(),
                              ),
                            );
                          },
                          itemBuilder:
                              (context) => [
                                PopupMenuItem(
                                  value: 'About',
                                  child: Text('About App'),
                                ),
                              ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "I N G R E D I E N T S",
                      style: GoogleFonts.ptSans(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          meal.ingredients.map((item) {
                            final ingredient = item['ingredient'] ?? '';
                            final measure = item['measure'] ?? '';
                            return Text(
                              '• $ingredient - $measure',
                              style: GoogleFonts.ptSans(),
                            ).animate().fade();
                          }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "H O W   T O   C O O K ?",
                      style: GoogleFonts.ptSans(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child:
                        Text(
                          meal.instructions,
                          style: GoogleFonts.ptSans(),
                        ).animate().fade(),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "V I D E O \t T U T O R I A L",
                      style: GoogleFonts.ptSans(fontSize: 20),
                    ),
                  ),
                  if (meal.youtubeVideoId != null)
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          final url = Uri.parse(
                            'https://www.youtube.com/watch?v=${meal.youtubeVideoId}',
                          );
                          if (!await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          )) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'This recipe was not added to Youtube yet.',
                                ),
                              ),
                            );
                          }
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://img.youtube.com/vi/${meal.youtubeVideoId}/0.jpg',
                                height: 200,
                                width: MediaQuery.of(context).size.width * 0.85,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, err) {
                                  return Image.asset(
                                    "assets/ytError.png",
                                    height: 200,

                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.85,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                            Icon(
                              Icons.play_circle_fill,
                              color: Colors.white,
                              size: 64,
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Data Source: Public API by TheMealDB",
                        style: GoogleFonts.ptSans(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
