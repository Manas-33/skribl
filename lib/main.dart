import 'package:flutter/material.dart';
import 'package:scribble/views/home_page.dart';
import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData.light().copyWith(scaffoldBackgroundColor: backgroundColor),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: HomePage(),
      ),
    );
  }
}
