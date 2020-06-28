import 'package:flutter/material.dart';
import 'file:///D:/shop/lib/Components/HomePageComponent/homepage.dart';
import 'package:flutterexamstarter/Components/SplashScreenComponent/splash_screen.dart';
import 'package:flutterexamstarter/Provider/MasterProvider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (BuildContext context) => MasterProvider(), child: MyApp(),));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'QuickSand',
        visualDensity: VisualDensity.adaptivePlatformDensity,

      ),

      home: SplashScreen(),
    );
  }
}


