import 'package:flutter/material.dart';
import 'package:expense_calculator/ui/mainpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Expense Calculator',

      home: HomePage(),
    );
  }
}

