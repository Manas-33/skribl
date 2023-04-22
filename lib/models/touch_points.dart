// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class TouchPoints {
  Paint paint;
  Offset points;
  TouchPoints({
    required this.paint,
    required this.points,
  });
  

  Map<String, dynamic> toJson() {
    return {
      'point':{'dx':'${points.dx}','dy':'${points.dy}'}
    };
  }
}
