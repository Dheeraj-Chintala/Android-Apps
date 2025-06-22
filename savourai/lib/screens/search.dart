import 'dart:convert';

import 'package:advanced_search/advanced_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:savourai/models/meal.dart';
import 'package:savourai/screens/mealpage.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final List<String> recipes = [
    "Chicken",
    "Spaghetti",
    "Cake",
    "Stew",
    "Pork",
    "Tofu",
    "Tuna",
    "Salad",
  ];
  List<Meal> searchedResult = [];
  Future<Meal?> fetchMeal(String recipe) async {
    final url = 'https://www.themealdb.com/api/json/v1/1/search.php?s=$recipe';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final mealsList = data['meals'] as List<dynamic>;

        if (mealsList.isNotEmpty) {
          for (int i = 0; i < mealsList.length; i++) {
            final meal = Meal.fromJson(mealsList[i]);
            searchedResult.add(meal);
          }
        }
      }
    } catch (e) {
      print('Error fetching meal: $e');
    }

    setState(() {});
    return null;
  }

  openMeal(String id) async {
    final url = 'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final mealsList = data['meals'] as List<dynamic>;

        if (mealsList.isNotEmpty) {
          final meal = Meal.fromJson(mealsList.first);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      MealPage(meal: meal, backgroundColor: Colors.amberAccent),
            ),
          );
        }
      }
    } catch (e) {
      print('Error fetching meal: $e');
    }

    setState(() {});
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 178, 135, 101),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Padding(
              padding: const EdgeInsets.all(10),
              child: AdvancedSearch(
                cursorColor: const Color.fromARGB(255, 0, 0, 0),
                inputTextFieldBgColor: const Color.fromARGB(198, 255, 255, 255),
                searchItems: recipes,
                maxElementsToDisplay: 7,
                singleItemHeight: 50,

                hintText: 'Search recipes',
                hintTextColor: const Color.fromARGB(255, 0, 0, 0),
                onItemTap: (index, value) {
                  print('Selected [$index]: $value');
                },
                onSubmitted: (recipe, _) {
                  searchedResult.clear();
                  fetchMeal(recipe);
                },
                borderColor: const Color.fromARGB(138, 0, 0, 0),
                searchResultsBgColor: Colors.black,
              ),
            ),
            if (searchedResult.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(searchedResult.length, (index) {
                    final meal = searchedResult[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GestureDetector(
                        onTap: () {
                          openMeal(meal.id);
                        },
                        child: Container(
                          color: const Color.fromARGB(255, 26, 26, 26),
                          child: Stack(
                            children: [
                              Image.network(meal.thumbnail, fit: BoxFit.cover),
                              Container(
                                alignment: Alignment.bottomLeft,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        meal.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "● ${meal.category ?? ''} ● ${meal.area ?? ''}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            if (searchedResult.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    LottieBuilder.asset("assets/cooking.json"),
                    const Text(
                      "Try Searching for Meals, Recipes, Dishes",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
