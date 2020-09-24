import 'package:flutter/material.dart';
import 'package:news_app/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "News App",
        debugShowCheckedModeBanner: false,
        //theme: ThemeData(brightness: Brightness.light),
        home: NewsHome());
  }
}
