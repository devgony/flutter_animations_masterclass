import 'package:flutter/material.dart';
import 'package:flutter_animations_masterclass/const.dart';
import 'package:rive/rive.dart';

class RiveScreenStars extends StatefulWidget {
  const RiveScreenStars({super.key});

  @override
  State<RiveScreenStars> createState() => _RiveScreenStarsState();
}

class _RiveScreenStarsState extends State<RiveScreenStars> {
  late final StateMachineController _stateMachineController;

  void _onInit(Artboard artboard) {
    _stateMachineController = StateMachineController.fromArtboard(
      artboard,
      stateMachine1,
      onStateChange: (stateMachineName, stateName) {
        print(stateMachineName);
        print(stateName);
      },
    )!;
    artboard.addController(_stateMachineController);
  }

  void _togglePanel() {
    final input = _stateMachineController.findInput<bool>("panelActive")!;
    input.change(!input.value);
  }

  @override
  void dispose() {
    _stateMachineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rive'),
      ),
      body: Center(
        child: Container(
          color: const Color(0xFFFF2ECC),
          width: double.infinity,
          child: RiveAnimation.asset(
            "assets/animations/stars-animation.riv",
            artboard: "New Artboard",
            onInit: _onInit,
            stateMachines: const [stateMachine1],
          ),
        ),
      ),
    );
  }
}
