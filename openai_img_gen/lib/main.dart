import 'package:flutter/material.dart';
import 'package:openai_img_gen/splashscr.dart';
import 'HomeScreen.dart';
import 'colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/splash',
      routes: {
        '/splash':(context)=>SplashScreen(),
        '/home':(context) => HomeScreen()
      },
      // home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      title: 'AI Image Generation',
      theme: ThemeData(
      fontFamily:'rowdy',
        scaffoldBackgroundColor:bgcolor, 
        appBarTheme: const AppBarTheme(
        color: Colors.transparent,
        elevation: 0,
      )
    ),
    );
  }
}

