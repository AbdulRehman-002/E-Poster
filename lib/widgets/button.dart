import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  Button({
    required this.text,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 42,
          width: 325,
          decoration: BoxDecoration(
              color: const Color(0xff221AAF),
              borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
