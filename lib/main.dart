import 'package:flutter/material.dart';
import 'package:food_explorer/screens/dashboard_screen.dart';
import 'package:food_explorer/screens/login_screen.dart';
import 'package:food_explorer/screens/profile_screen.dart';
import 'package:food_explorer/screens/recipe_detail_screen.dart';
import 'package:food_explorer/screens/recipes_screen.dart';

void main() =>
  runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF2874F0)
      ),
      routes: {
        '/': (context) => DashboardScreen(),
        '/dashboard_screen': (context) => DashboardScreen(),
        '/recipes_screen': (context) => RecipesScreen(),
        '/recipe_detail_screen': (context) => RecipeDetailScreen(),
        '/profile_screen': (context) => ProfileScreen(),
        '/login_screen': (context) => LoginScreen(),
      },
    );
  }
}
