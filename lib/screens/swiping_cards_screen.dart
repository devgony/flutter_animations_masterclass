import 'dart:math';

import 'package:flutter/material.dart';

enum ActiveButton {
  close,
  check,
  none,
}

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({super.key});

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<SwipingCardsScreen>
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;

  ActiveButton _active = ActiveButton.none;

  late final AnimationController _position = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
    lowerBound: (size.width + 100) * -1,
    upperBound: (size.width + 100),
    value: 0.0,
  );

  late final Tween<double> _rotation = Tween(
    begin: -15,
    end: 15,
  );

  late final Tween<double> _scale = Tween(
    begin: 0.8,
    end: 1,
  );

  late final Tween<double> _opacity = Tween(
    begin: 0,
    end: 1,
  );

  late final ColorTween _colorClose = ColorTween(
    begin: Colors.white,
    end: Colors.red,
  );

  late final ColorTween _colorCheck = ColorTween(
    begin: Colors.white,
    end: Colors.green,
  );

  late final ColorTween _fontColorClose = ColorTween(
    begin: Colors.red, // TODO: should reuse _colorClose
    end: Colors.white,
  );

  late final ColorTween _fontColorCheck = ColorTween(
    begin: Colors.green,
    end: Colors.white,
  );

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final bound = size.width - 200;
    _position.value += details.delta.dx;

    if (_position.value.isNegative && _active != ActiveButton.close) {
      setState(() {
        _active = ActiveButton.close;
      });
    }

    if (_position.value > 0 && _active != ActiveButton.check) {
      setState(() {
        _active = ActiveButton.check;
      });
    }
  }

  void _whenComplete() {
    _position.value = 0;
    setState(() {
      _index = _index == 5 ? 1 : _index + 1;
      _active = ActiveButton.none;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    print(details);
    final bound = size.width - 200;
    final dropZone = size.width + 100;
    if (_position.value.abs() >= bound) {
      if (_position.value.isNegative) {
        _position.animateTo((dropZone) * -1).whenComplete(_whenComplete);
      } else {
        _position.animateTo(dropZone).whenComplete(_whenComplete);
      }
    } else {
      _position.animateTo(
        0,
        curve: Curves.easeOut,
      );
    }
  }

  void _onTapClose() {
    _position
        .animateTo(
          (size.width + 100) * -1,
          curve: Curves.easeOut,
        )
        .whenComplete(_whenComplete);
    setState(() {
      _active = ActiveButton.close;
    });
  }

  void _onTapCheck() {
    _position
        .animateTo(
          (size.width + 100),
          curve: Curves.easeOut,
        )
        .whenComplete(_whenComplete);
    setState(() {
      _active = ActiveButton.check;
    });
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  int _index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swiping Cards'),
      ),
      body: AnimatedBuilder(
        animation: _position,
        builder: (context, child) {
          final angle = _rotation.transform(
                (_position.value + size.width / 2) / size.width,
              ) *
              pi /
              180;
          final valueOnWidth = _position.value.abs() / size.width;
          final scale = _scale.transform(valueOnWidth);
          final colorClose = _colorClose.transform(valueOnWidth);
          final colorCheck = _colorCheck.transform(valueOnWidth);
          final fontColorClose = _fontColorClose.transform(valueOnWidth);
          final fontColorCheck = _fontColorCheck.transform(valueOnWidth);

          return Column(
            children: [
              Flexible(
                flex: 4,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      top: 100,
                      child: Transform.scale(
                        scale: scale,
                        child: Card(index: _index == 5 ? 1 : _index + 1),
                      ),
                    ),
                    Positioned(
                      top: 100,
                      child: GestureDetector(
                        onHorizontalDragUpdate: _onHorizontalDragUpdate,
                        onHorizontalDragEnd: _onHorizontalDragEnd,
                        child: Transform.translate(
                          offset: Offset(_position.value, 0),
                          child: Transform.rotate(
                            angle: angle,
                            child: Card(index: _index),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(
                      2,
                      (index) => Transform.scale(
                        scale: _active == ActiveButton.values[index]
                            ? scale + 0.2
                            : 1,
                        child: InkWell(
                          onTap: index == 0 ? _onTapClose : _onTapCheck,
                          child: Container(
                            width: 80,
                            height: 80,
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: _active == ActiveButton.values[index]
                                  ? index == 0
                                      ? colorClose
                                      : colorCheck
                                  : Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                              border: const Border.fromBorderSide(
                                BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              index == 0 ? Icons.close : Icons.check,
                              // color: index == 0 ? Colors.red : Colors.green,
                              color: _active == ActiveButton.values[index]
                                  ? index == 0
                                      ? fontColorClose
                                      : fontColorCheck
                                  : index == 0
                                      ? Colors.red
                                      : Colors.green,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Card extends StatelessWidget {
  final int index;

  const Card({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.5,
        child: Image.asset(
          "assets/covers/$index.jpg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
