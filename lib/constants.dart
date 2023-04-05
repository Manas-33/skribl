import 'package:flutter/material.dart';

const backgroundColor = Colors.blue;
var secondaryColor = Colors.white;
// var secondary = Colors.indigo;
final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();
/*
ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [
                    Colors.red,
                    Colors.orange,
                    Colors.yellow,
                    Colors.green,
                    Colors.blue,
                    Colors.indigo,
                    Colors.purple
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: Text(
                'Hello, world!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
*/