import 'package:flutter/material.dart';
import 'package:flutter_animations_masterclass/const.dart';
import 'package:rive/rive.dart';

class RiveScreenButton extends StatefulWidget {
  const RiveScreenButton({super.key});

  @override
  State<RiveScreenButton> createState() => _RiveScreenButtonState();
}

class _RiveScreenButtonState extends State<RiveScreenButton> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rive-button'),
      ),
      body: Stack(
        children: const [
          RiveAnimation.asset(
            "assets/animations/custom-button-animation.riv",
            stateMachines: [stateMachine1],
          ),
          Center(
            child: Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
          )
        ],
      ),
    );
  }
}
