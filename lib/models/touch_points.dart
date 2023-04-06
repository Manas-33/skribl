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
      // 'paint': paint.toMap(),
      // 'offset': offset.toMap(),
    };
  }

  // factory TouchPoints.fromMap(Map<String, dynamic> map) {
  //   return TouchPoints(
  //     paint: Paint.fromMap(map['paint'] as Map<String,dynamic>),
  //     offset: Offset.fromMap(map['offset'] as Map<String,dynamic>),
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory TouchPoints.fromJson(String source) => TouchPoints.fromMap(json.decode(source) as Map<String, dynamic>);
}
