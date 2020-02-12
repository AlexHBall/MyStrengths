import 'package:flutter/material.dart';
import 'screens/strength_list.dart';
void main() {
  runApp(MyStrengths());
}

class MyStrengths extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyStengths',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyStrenghtsList(),
    );
  }
}
