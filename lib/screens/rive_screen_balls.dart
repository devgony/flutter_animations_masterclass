import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveScreenBalls extends StatefulWidget {
  const RiveScreenBalls({super.key});

  @override
  State<RiveScreenBalls> createState() => _RiveScreenBallsState();
}

class _RiveScreenBallsState extends State<RiveScreenBalls> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const RiveAnimation.asset(
            "assets/animations/balls-animation.riv",
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: const Center(
                child: Text(
                  "Welcome to AI App",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
