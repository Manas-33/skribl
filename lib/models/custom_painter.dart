import 'package:flutter/material.dart';
import 'package:scribble/models/drawing_point.dart';
import 'dart:ui' as ui;

class MyCustomPainter extends CustomPainter {
  List<DrawingPoint?> pointsList;
  MyCustomPainter({required this.pointsList});

  List<Offset> offsetPoints = [];

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);
    canvas.clipRect(rect);

    //logic for points,

    for (int i = 0; i < pointsList.length ; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        //line then connect the line of points
        canvas.drawLine(pointsList[i]!.offset, pointsList[i + 1]!.offset,
            pointsList[i]!.paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        //point then point
        offsetPoints.clear();
        offsetPoints.add(pointsList[i]!.offset);
        canvas.drawPoints(
            ui.PointMode.points, offsetPoints, pointsList[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
