import 'package:flutter/material.dart';
import 'package:food_explorer/screens/dashboard_screen.dart';

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
      },
    );
  }
}
