import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:scribble/models/touch_points.dart';

class MyCustomPainter extends CustomPainter {
  List<TouchPoints> pointsList;
  MyCustomPainter({required this.pointsList});

  List<Offset> offsetPoints = [];

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);
    canvas.clipRect(rect);

    //logic for points,

    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        //line then connect the line of points
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
            pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        //point then point
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        offsetPoints.add(
            Offset(pointsList[i].points.dx + .1, pointsList[i].points.dy + .1));
        canvas.drawPoints(
            ui.PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
