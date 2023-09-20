import 'dart:math';

import 'package:flutter/material.dart';

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({super.key});

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen>
    with TickerProviderStateMixin {
  double _randomEnd() => Random().nextDouble() * 2.0;

  Map<String, dynamic> getAnimationProps() {
    final AnimationController animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    final CurvedAnimation curve = CurvedAnimation(
      parent: animationController,
      curve: Curves.bounceOut,
    );

    Animation<double> progress = Tween(
      begin: 0.005,
      end: _randomEnd(),
    ).animate(curve);

    return {
      "animationController": animationController,
      "curve": curve,
      "progress": progress,
    };
  }

  late final prop1 = getAnimationProps();
  late final prop2 = getAnimationProps();
  late final prop3 = getAnimationProps();

  late final AnimationController _animationController1 =
      prop1["animationController"];
  late final AnimationController _animationController2 =
      prop2["animationController"];
  late final AnimationController _animationController3 =
      prop3["animationController"];

  late final CurvedAnimation _curve1 = prop1["curve"];
  late final CurvedAnimation _curve2 = prop2["curve"];
  late final CurvedAnimation _curve3 = prop3["curve"];

  late Animation<double> _progress1 = prop1["progress"];
  late Animation<double> _progress2 = prop2["progress"];
  late Animation<double> _progress3 = prop3["progress"];

  void _animateValues() {
    // forward again onPressed
    setState(() {
      _progress1 =
          Tween(begin: _progress1.value, end: _randomEnd()).animate(_curve1);

      _progress2 =
          Tween(begin: _progress2.value, end: _randomEnd()).animate(_curve2);

      _progress3 =
          Tween(begin: _progress3.value, end: _randomEnd()).animate(_curve3);
    });
    _animationController1.forward(from: 0);
    _animationController2.forward(from: 0);
    _animationController3.forward(from: 0);
  }

  late final Listenable _listenable = Listenable.merge([
    _animationController1,
    _animationController2,
    _animationController3,
  ]);

  @override
  void dispose() {
    _animationController1.dispose();
    _animationController2.dispose();
    _animationController3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Apple Watch"),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _listenable,
          builder: (context, child) {
            return CustomPaint(
              painter: AppleWatchPainter(
                progress1: _progress1.value,
                progress2: _progress2.value,
                progress3: _progress3.value,
              ),
              size: const Size(400, 400),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _animateValues,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class AppleWatchPainter extends CustomPainter {
  final double progress1;
  final double progress2;
  final double progress3;

  AppleWatchPainter({
    required this.progress1,
    required this.progress2,
    required this.progress3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    const startingAngle = -0.5 * pi; // -90 degree (cf. +2.0 = 360 degree)

    // draw red
    final redCirclePaint = Paint()
      ..color = Colors.red.shade400.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    final redCircleRadius = (size.width / 2) * 0.9;

    canvas.drawCircle(
      center,
      redCircleRadius,
      redCirclePaint,
    );
    // draw green

    final greenCircleRadius = (size.width / 2) * 0.76;

    final greenCircle = Paint()
      ..color = Colors.green.shade400.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;
    canvas.drawCircle(
      center,
      greenCircleRadius,
      greenCircle,
    );
    // draw blue
    final blueCircle = Paint()
      ..color = Colors.cyan.shade400.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    final blueCircleRadius = (size.width / 2) * 0.62;

    canvas.drawCircle(
      center,
      blueCircleRadius,
      blueCircle,
    );

    // red arc

    final redArcRect = Rect.fromCircle(
      center: center,
      radius: redCircleRadius,
    );

    final redArcPaint = Paint()
      ..color = Colors.red.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round // default: butt (noCaps)
      ..strokeWidth = 25;

    canvas.drawArc(
      redArcRect,
      startingAngle,
      progress1 * pi, // degree from startingAngle
      false,
      redArcPaint,
    );

    // green arc

    final greenArcRect = Rect.fromCircle(
      center: center,
      radius: greenCircleRadius,
    );

    final greenArcPaint = Paint()
      ..color = Colors.green.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;

    canvas.drawArc(
      greenArcRect,
      startingAngle,
      progress2 * pi,
      false,
      greenArcPaint,
    );

    // blue arc

    final blueArcRect = Rect.fromCircle(
      center: center,
      radius: blueCircleRadius,
    );

    final blueArcPaint = Paint()
      ..color = Colors.cyan.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;

    canvas.drawArc(
      blueArcRect,
      startingAngle,
      progress3 * pi,
      false,
      blueArcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant AppleWatchPainter oldDelegate) {
    return oldDelegate.progress1 != progress1 ||
        oldDelegate.progress2 != progress2 ||
        oldDelegate.progress3 != progress3;
  }
}
