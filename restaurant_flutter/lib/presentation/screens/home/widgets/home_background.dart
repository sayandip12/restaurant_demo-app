import 'package:flutter/material.dart';

class HomeBackground extends StatelessWidget {
  const HomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100,
      left: 0,
      right: 0,
      child: Opacity(
        opacity: 0.08,
        child: Image.asset(
          'assets/images/hero/kolkata_bg.png',
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }
}
