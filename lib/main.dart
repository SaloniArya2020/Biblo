import 'package:biblo/Screens/home_screen.dart';
import 'package:biblo/UI_elements/colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black54),
          color: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: primaryTextColor,
          backgroundColor: primaryAccentColor
        ),
        primaryColor: primaryColor,
       scaffoldBackgroundColor: Colors.white,
        fontFamily: 'workSans'
      ),
      home:HomeScreen());
  }
}

