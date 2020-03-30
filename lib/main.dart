import 'package:flutter/material.dart';
import 'ui/strength_list.dart';
import 'utils/theme.dart';

void main() {
  runApp(MyStrengths());
}

class MyStrengths extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: basicTheme(),
      debugShowCheckedModeBanner: false  ,
      home: MyStrenghtsList(),
    );
  }
}
