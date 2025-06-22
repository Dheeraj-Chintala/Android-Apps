import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:savourai/models/meal.dart';
import 'package:savourai/screens/mealpage.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final PageController pageController = PageController();
  final List<Meal> meals = [];
  final List<Color> colors = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadMoreMeals();

    pageController.addListener(() {
      if (pageController.page != null &&
          pageController.page!.round() >= meals.length - 1 &&
          !loading) {
        loadMoreMeals();
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }


  Future<void> getColorsFromImage(String imageUrl) async {
    try {
      final palette = await PaletteGenerator.fromImageProvider(
        NetworkImage(imageUrl),
      );
      colors.add(palette.lightVibrantColor?.color ?? const Color(0xFFFFDD6E));
    } catch (e) {
      colors.add(const Color(0xFFFFDD6E));
    }
  }

  Future<void> loadMoreMeals() async {
    setState(() => loading = true);

    for (int i = 0; i < 4; i++) {
      final meal = await fetchRandomMeal();
      if (meal != null) {
        meals.add(meal);
        await getColorsFromImage(meal.thumbnail);
        
      }
    }
    

    setState(() => loading = false);
  }

  Future<Meal?> fetchRandomMeal() async {
    const url = 'https://www.themealdb.com/api/json/v1/1/random.php';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final mealsList = data['meals'] as List<dynamic>;
        if (mealsList.isNotEmpty) {
          return Meal.fromJson(mealsList.first);
        }
      }
    } catch (e) {
      print('Error fetching meal: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body:
          meals.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: pageController,
                itemCount: meals.length ,

                itemBuilder: (context, index) {
                  return MealPage(
                    meal: meals[index],
                    backgroundColor: colors[index],
                    key: PageStorageKey(meals[index].id),
                  );
                  
                },
              ),
    );
  }
}
