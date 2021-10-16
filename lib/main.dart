import 'package:expandable_navbar/screens/main_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: MainExpandableNavBar(),
      theme: ThemeData.dark(),
    );
  }
}