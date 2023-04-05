import 'package:flutter/material.dart';
import 'package:scribble/views/create_room_page.dart';
import 'package:scribble/views/home_page.dart';
import 'package:scribble/views/join_room_page.dart';
import 'package:scribble/views/paint_page.dart';

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
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}
