import 'package:flutter/material.dart';
import 'dart:ui' as vcb;

class CustomButton extends StatelessWidget {
  final double factor;
  final vcb.VoidCallback onTap;
  final IconData icon;
  final String text;
  CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.icon,
    required this.factor,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            minimumSize: Size(MediaQuery.of(context).size.width / factor, 50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))),
        onPressed: onTap,
        icon: SizedBox(width: 35, height: 35, child: Icon(icon)),
        label: Text(text, style: TextStyle(fontSize: 16)));
  }
}
