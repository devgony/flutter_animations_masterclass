import 'package:flutter/material.dart';
import 'package:flutter_animations_masterclass/const.dart';

import 'package:rive/rive.dart';

class RiveScreenOldMan extends StatefulWidget {
  const RiveScreenOldMan({super.key});

  @override
  State<RiveScreenOldMan> createState() => _RiveScreenOldManState();
}

class _RiveScreenOldManState extends State<RiveScreenOldMan> {
  late final StateMachineController _stateMachineController;

  void _onInit(Artboard artboard) {
    _stateMachineController = StateMachineController.fromArtboard(
      artboard,
      stateMachine1,
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
        child: Column(
          children: [
            SizedBox(
              height: 500,
              width: double.infinity,
              child: RiveAnimation.asset(
                "assets/animations/old-man-animation.riv",
                artboard: "Dwarf Panel",
                onInit: _onInit,
                stateMachines: const [stateMachine1],
              ),
            ),
            ElevatedButton(
              onPressed: _togglePanel,
              child: const Text("Go!"),
            )
          ],
        ),
      ),
    );
  }
}
