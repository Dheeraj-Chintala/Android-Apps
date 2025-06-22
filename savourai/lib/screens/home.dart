import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:savourai/models/meal.dart';
import 'package:savourai/screens/chat.dart';
import 'package:savourai/screens/feed.dart';
import 'package:savourai/screens/search.dart';
import 'package:savourai/services/connectivityservice.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ConnectivityService connectivityService = ConnectivityService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectivityService.checkConnectivity(context);
  }

  Future<Meal?> fetchRandomMeal() async {
    const url = 'https://www.themealdb.com/api/json/v1/1/random.php';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final meals = data['meals'] as List<dynamic>;
        if (meals.isNotEmpty) {
          return Meal.fromJson(meals.first);
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Fetch error: $e');
    }

    return null;
  }

  void loadMeal() async {
    final meal = await fetchRandomMeal();
    setState(() {
      fetchedMeal = meal;
    });
    if (meal != null) {
      print('Meal: ${meal.name}');
      if (meal.youtubeUrl != null) {
        print('YouTube: ${meal.youtubeUrl}');
      }
      for (var ing in meal.ingredients) {
        print('${ing['ingredient']} - ${ing['measure']}');
      }
    } else {
      print('No meal found.');
    }
  }

  late Meal? fetchedMeal = Meal(
    id: "",
    name: "",
    category: "",
    area: "",
    instructions: "",
    thumbnail: "",
    ingredients: [],
  );
  final pages = [Feed(), Search(), Chat()];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      extendBody: true,

      bottomNavigationBar: CrystalNavigationBar(
        borderRadius: 15,
        currentIndex: selectedIndex,
        unselectedItemColor: const Color.fromARGB(215, 255, 255, 255),
        backgroundColor: Colors.black.withOpacity(0.1),
        outlineBorderColor: Colors.white,
        onTap:
            (index) => {
              if (index == 2)
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Chat()),
                  ),
                }
              else
                {setState(() => selectedIndex = index)},
            },
        items: [
          CrystalNavigationBarItem(
            icon: IconlyBold.home,
            unselectedIcon: IconlyLight.home,
            selectedColor: Colors.brown,
          ),

          CrystalNavigationBarItem(
            icon: IconlyBold.search,
            unselectedIcon: IconlyLight.search,
            selectedColor: Colors.orange,
          ),

          CrystalNavigationBarItem(
            icon: IconlyBold.chat,
            unselectedIcon: IconlyLight.chat,
            selectedColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}
