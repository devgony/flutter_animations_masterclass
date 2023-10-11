> # flutter_animations_masterclass

# 1 IMPLICIT ANIMATIONS

## 1.0 Project Setup

```
flutter create flutter_animations_masterclass
cd flutter_animations_masterclass
mkdir -p lib/screens
touch lib/screens/menu_screen.dart
touch lib/screens/implicit_animations_screen.dart
```

## 1.1 Implicitly Animated Widgets

- [Implicit Animations](https://docs.flutter.dev/ui/widgets/animation)

## 1.2 AnimatedContainer

- it covers most of the animation properties

## 1.3 Curves

- [Curves class](https://api.flutter.dev/flutter/animation/Curves-class.html) controlls the acceleration of the animation
- default: [linear](https://api.flutter.dev/flutter/animation/Curves/linear-constant.html)
- recommanded: [elasticOut](https://api.flutter.dev/flutter/animation/Curves/elasticOut-constant.html)

## 1.4 TweenAnimationBuilder

- still implicit but when their is not suit option in implicit widgets

```dart
// implicit_animations_screen.dart
TweenAnimationBuilder(
    tween: ColorTween(
    begin: Colors.yellow,
    end: Colors.red,
    ),
    curve: Curves.bounceInOut,
    duration: const Duration(seconds: 5),
    builder: (context, value, child) {
    return Image.network(
        "https://upload.wikimedia.org/wikipedia/commons/4/4f/Dash%2C_the_mascot_of_the_Dart_programming_language.png",
        color: value,
        colorBlendMode: BlendMode.colorBurn,
    );
    },
),
```

# 2 EXPLICIT ANIMATIONS

## 2.0 Implicit vs Explicit

- https://docs.flutter.dev/ui/animations  
  ![animation-decision-tree](/md_images/animation-decision-tree.png)

## 2.1 AnimationController

```sh
touch lib/screens/explicit_animations_screen.dart
```

- Tiker
  - calls its callback once per animation frame
  - it still runs `even after leaving widget tree`

```dart
void initState() {
    super.initState();
    Ticker((elapsed) => print(elapsed)).start();
}
```

- SingleTickerProviderStateMixin
  - Provides a `single Ticker` that is configured to `only tick while the current tree is enabled`
  - if more than two animationControllers, use TickerProviderStateMixin

## 2.2 Animation Values

```dart
void _play() {
    _animationController.forward();
}

void _pause() {
    _animationController.stop();
}

void _rewind() {
    _animationController.reverse();
}
...
void initState() {
  super.initState();
  Timer.periodic(const Duration(milliseconds: 500), (timer) {
    print(_animationController.value); // no build issue => print just for now
  });
}
```

1. animationController goes from 0 to 1
2. it has forward, stop, reverse
3. it does not build again

## 2.3 AnimatedBuilder

```dart
AnimatedBuilder(
    animation: _animationController,
    builder: (context, child) {
        return Opacity(
            opacity: _animationController.value,
            child: Container(
            color: Colors.amber,
            width: 400,
            height: 400,
            ),
        );
    },
),
```

- build was called once => only AnimatedBuilder is called again

## 2.4 ColorTween

```dart
late final Animation<Color?> _color =
     ColorTween(begin: Colors.amber, end: Colors.red)
         .animate(_animationController);
..
AnimatedBuilder(
  animation: _color,
..
```

- instead of using naive value, inject controller to ColorTween

## 2.5 Explicit Widgets

- using AnimatedBuilder all the time is verbose
  - wrap with explicit widget
- explicit widget naming rule: ~Transition eg) `SlideTransition`
  - [Explicit Animations](https://docs.flutter.dev/ui/widgets/animation)
- DecoratedBoxTransition + DecorationTween: define start and begin of multiple properties

```dart
late final Animation<Decoration> _decoration = DecorationTween(
  begin: BoxDecoration(
    color: Colors.amber,
    borderRadius: BorderRadius.circular(20),
  ),
  end: BoxDecoration(
    color: Colors.red,
    borderRadius: BorderRadius.circular(120),
  ),
).animate(_animationController);

late final Animation<double> _rotation = Tween(
  begin: 0.0,
  end: 2.0,
).animate(_animationController);

late final Animation<double> _scale = Tween(
  begin: 1.0,
  end: 1.1,
).animate(_animationController);

late final Animation<Offset> _position = Tween(
  begin: Offset.zero,
  end: const Offset(0, -0.2),
).animate(_animationController);
..
SlideTransition(
  position: _position,
  child: ScaleTransition(
    scale: _scale,
    child: RotationTransition(
      turns: _rotation,
      child: DecoratedBoxTransition(
        decoration: _decoration,
        child: const SizedBox(
          height: 400,
          width: 400,
        ),
      ),
    ),
  ),
)
```

## 2.6 CurvedAnimation

- inject CurvedAnimation instead of AnimationController

```dart
late final CurvedAnimation _curve = CurvedAnimation(
  parent: _animationController,
  curve: Curves.elasticOut,
  reverseCurve: Curves.bounceIn,
);
..
late final Animation<double> _rotation = Tween(
  begin: 0.0,
  end: 0.5,
).animate(_curve);
```

## 2.7 ValueNotifier

- holds value to render only specific ValueListenableBuilder

```dart
late final AnimationController _animationController = AnimationController(
  vsync: this,
  duration: const Duration(seconds: 2),
  reverseDuration: const Duration(seconds: 1),
)..addListener(() {
  _range.value = _animationController.value; // hold contorller.value to ValueNotifier
});
..
final ValueNotifier<double> _range = ValueNotifier(0.0);

void _onChanged(double value) {
  _range.value = 0; // why does it initialize ValueNotifier?
  _animationController.value = value; // _animationController.animateTo(value) sets value with animation
}
..
ValueListenableBuilder(
  valueListenable: _range,
  builder: (context, value, child) {
    return Slider(
      value: value,
      onChanged: _onChanged,
    );
  },
)
```

## 2.8 AnimationStatus

- AnimationStatus serves dismissed, forward, reverse, completed

```dart
// loop example by AnimationStatus
late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
    reverseDuration: const Duration(seconds: 1),
  )
    ..addListener(() {
      _range.value = _animationController.value;
    })
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
```

- shorten way to loop

```dart
bool _looping = false;

void _toggleLooping() {
  if (_looping) {
    _animationController.stop();
  } else {
    _animationController.repeat(reverse: true);
  }
  setState(() {
    _looping = !_looping;
  });
}
```

# 3 APPLE WATCH PROJECT

## 3.0 CustomPainter

- CustomPainter should override `paint`, `shouldRepaint`

- Draw canvas

```dart
// touch lib/screens/apple_watch_screen.dart
CustomPaint(
  painter: AppleWatchPainter(),
  size: const Size(400, 400),
),
```

- Rect

```dart
final rect = Rect.fromLTWH(
  0,
  0,
  size.width,
  size.height,
);

final paint = Paint()..color = Colors.blue;

canvas.drawRect(rect, paint);
```

- Circle

```dart
final circlePaint = Paint()
  ..color = Colors.red
  ..style = PaintingStyle.stroke
  ..strokeWidth = 20;

canvas.drawCircle(
  Offset(size.width / 2, size.width / 2),
  size.width / 2,
  circlePaint,
);
```

## 3.1 drawArc

### Circle

- storke: lines around circle
- fill: fill whole circle

```dart
final redCirclePaint = Paint()
  ..color = Colors.red.shade400.withOpacity(0.3)
  ..style = PaintingStyle.stroke
  ..strokeWidth = 25;

final redCircleRadius = (size.width / 2) * 0.9;

canvas.drawCircle(
  center, // offset
  redCircleRadius,
  redCirclePaint,
);
```

### Arch

- define rect as canvas of arch

```dart
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
  redArcRect,  // canvas rect
  -0.5 * pi,   // startAngle
  1.5 * pi,    // sweep(end)Angle
  false,       // draw radius
  redArcPaint,
);
```

## 3.2 shouldRepaint

- impl animationController

```dart
late final AnimationController _animationController = AnimationController(
  vsync: this,
  duration: const Duration(seconds: 2),
  lowerBound: 0.005, // 0.. degree
  upperBound: 2.0, // 360 degree
);
```

- render by AnimatedBuilder

```dart
child: AnimatedBuilder(
  animation: _animationController,
  builder: (context, child) {
    return CustomPaint(
      painter: AppleWatchPainter(
        progress: _animationController.value,
      ),
      size: const Size(400, 400),
    );
  },
),
..
class AppleWatchPainter extends CustomPainter {
  final double progress;
  ..
  const startingAngle = -0.5 * pi; // -90 degree (cf. +2.0 = 360 degree)
  ..
  canvas.drawArc(
    redArcRect,
    startingAngle,
    progress * pi, // degree from startingAngle
    false,
    redArcPaint,
  );
```

- only when `shouldRepaint` returns true, it rerenders

```dart
bool shouldRepaint(covariant AppleWatchPainter oldDelegate) {
  return oldDelegate.progress != progress;
}
```

## 3.3 Random()

- impl custom CurvedAnimation
- don't forget to dispose

```dart
late final AnimationController _animationController = AnimationController(
  vsync: this,
  duration: const Duration(seconds: 2),
  // lowerBound: 0.005, // 0.. degree
  // upperBound: 2.0, // 360 degree
)..forward(); // fire forward at first render with _curve defined below

late final CurvedAnimation _curve = CurvedAnimation(
  parent: _animationController,
  curve: Curves.bounceOut,
);

late Animation<double> _progress = Tween(
  begin: 0.005,
  end: 1.5,
).animate(_curve);

void _animateValues() {
  // forward again onPressed
  final newBegin = _progress.value;
  final random = Random();
  final newEnd = random.nextDouble() * 2.0;
  setState(() {
    _progress = Tween(
      begin: newBegin,
      end: newEnd,
    ).animate(_curve);
  });
  _animationController.forward(from: 0);
}

@override
void dispose() {
  _animationController.dispose();
  super.dispose();
}
..
child: AnimatedBuilder(
  animation: _progress,
  ..
  painter: AppleWatchPainter(
    progress: _progress.value,
```

## 3.4 Code Challenge

1. end of first Tween should be random
2. onPress => different Tween for each Arc

Challenge: https://imgur.com/a/flFwHL5

# 4 SWIPING CARDS PROJECT

## 4.0 Swiping Gesture

- `_onHorizontalDragUpdate`
- `_onHorizontalDragEnd`

```sh
touch lib/screens/swiping_cards_screen.dart
```

- import images

```
mkdir -p assets/covers
# download 5 images
```

```yaml
# pubspec.yaml
assets:
  - assets/
  - assets/covers/
```

## 4.1 Bounds

- value sets initial state of controller

```dart
late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
    lowerBound: size.width * -1,
    upperBound: size.width,
    value: 0.0, // init: middle of lower and upper
  );
```

```dart
void _onHorizontalDragEnd(DragEndDetails details) {
  _animationController.animateTo(
    0,
    curve: Curves.bounceOut,
  );
}
```

## 4.2 Tween Transform

- transform interpolates controller.value to tween

```
-250    ..    0    175    250
 250    ..    0    11.2   15
```

```dart
late final Tween<double> _rotation = Tween(
  begin: -15,
  end: 15,
);
..
final angle = _rotation.transform(
  (_position.value + size.width / 2) / size.width,
) *
pi /
180
```

## 4.3 Dismiss Card

- set bound to hide card out of screen

```dart
void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = size.width - 200;
    final dropZone = size.width + 100;
    if (_position.value.abs() >= bound) {
      if (_position.value.isNegative) {
        _position.animateTo((dropZone) * -1);
      } else {
        _position.animateTo(dropZone);
      }
    } else {
      _position.animateTo(
        0,
        curve: Curves.easeOut,
      );
    }
  }
```

## 4.4 Background Card

- unshiff another card to stack
- add scale animation

```dart
late final Tween<double> _scale = Tween(
  begin: 0.8,
  end: 1,
);
..
final scale = _scale.transform(_position.value.abs() / size.width);
```

## 4.5 Cards

- reset animationController + add index => infinite swipe hallucination

```dart
void _whenComplete() {
  _position.value = 0;
  setState(() {
    _index = _index == 5 ? 1 : _index + 1;
  });
}
```

## 4.6 Code Challenge

- refactor whenComplete
- wrap with `min` to prohibit overscaling

### Submit

https://imgur.com/a/1zY2VSL

### Question:

- how to reuse `_colorClose` for \_`_fontColorClose`? like reversing
- how to change color value to white at bound with single ticker?

# 5 MUSIC PLAYER PROJECT

## 5.0 Album PageView

```dart
// touch lib/screens/music_player_screen.dart

final PageController _pageController = PageController(
  viewportFraction: 0.8,
);
```

## 5.1 AnimatedSwitcher

- `ValueKey`: inform to Widget it is changed => transition works

```dart
AnimatedSwitcher (
  duration: const Duration(milliseconds: 500),
  child: Container(
    key: ValueKey(_currentPage),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(
          "assets/covers/${_currentPage + 1}.jpg",
        ),
        fit: BoxFit.cover,
      ),
    ),
    child: BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 20,
        sigmaY: 20,
      ),
      child: Container(
        color: Colors.black.withOpacity(0.5),
      ),
    ),
  ),
)
```

## 5.2 Album Scale

- To render only specific area => use `ValueNotifier` rather than setState

```dart
final ValueNotifier<double> _scroll = ValueNotifier(0.0);
..
ValueListenableBuilder(
  valueListenable: _scroll,
  builder: (context, scroll, child) {
    final difference = (scroll - index).abs();
    final scale = 1 - (difference * 0.1);
    return Transform.scale(
      scale: scale,
      ..
```

## 5.3 Hero

```
touch lib/screens/music_player_detail_screen.dart
```

```dart
// music_player_screen.dart
..
return GestureDetector(
  onTap: () => _onTap(index),
  child: Hero(
    tag: "${index + 1}",
    child: Transform.scale(
    ..
```

## 5.4 PageRouteBuilder

- PageRouteBuilder supports transition like FadeTransition, ScaleTransition..

```dart
void _onTap(int imageIndex) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: MusicPlayerDetailScreen(
            index: imageIndex,
          ),
        );
      },
    ),
  );
}
```

## 5.5 ProgressBar

```dart
class ProgressBar extends CustomPainter {
  final double progressValue;

  ProgressBar({
    required this.progressValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // track

    final trackPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;

    final trackRRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(trackRRect, trackPaint);

    // progress
    final progressPaint = Paint()
      ..color = Colors.grey.shade500
      ..style = PaintingStyle.fill;

    final progressRRect = RRect.fromLTRBR(
      0,
      0,
      progressValue,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(progressRRect, progressPaint);

    // thumb

    canvas.drawCircle(
      Offset(progressValue, size.height / 2),
      10,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ProgressBar oldDelegate) {
    return false;
  }
}
```

## 5.6 Progress Animation

```dart
late final AnimationController _progressController = AnimationController(
    vsync: this,
    duration: const Duration(minutes: 1),
  )..repeat(reverse: true);
..
final progress = size.width * progressValue;
```

## 5.7 Code Challenge

- lecture: render stateless time and title
- challenge: render stateful time up to animationController

## 5.8 Marquee

- A html element scrolling area of text

```dart
late final Animation<Offset> _marqueeTween = Tween(
  begin: const Offset(0.1, 0),
  end: const Offset(-0.6, 0),
).animate(_marqueeController);
..
SlideTransition(
  position: _marqueeTween,
  child: const Text(
    "A Film By Christopher Nolan - Original Motion Picture Soundtrack",
    maxLines: 1,
    overflow: TextOverflow.visible,
    softWrap: false,
    style: TextStyle(fontSize: 18),
  ),
),
```

## 5.9 Lottie

```dart
// mkdir assets/animations
// touch assets/animations/play-lottie.json

//pubspec.yaml
assets:
  - assets/animations/
```

- AnimatedIcon supports standard icons with animation but few.
- download lottie json file https://lottiefiles.com/animation/flutter

```dart
AnimatedIcon(
  icon: AnimatedIcons.play_pause,
  progress: _playPauseController,
  size: 60,
),
LottieBuilder.asset(
  "assets/animations/play-lottie.json",
  controller: _playPauseController,
  width: 200,
  height: 100,
)
```

## 5.10 VolumePainter

- clamp: set fixed min and max

```dart
_volume.value = _volume.value.clamp(
  0.0,
  size.width - 80,
);
```

## 5.11 Covered Menu

- prepare first stacked child for menu

## 5.12 Interval

- Scale & Slide transition

```dart
final Curve _menuCurve = Curves.easeInOutCubic;

late final Animation<double> _screenScale = Tween(
  begin: 1.0,
  end: 0.7,
).animate(
  CurvedAnimation(
    parent: _menuController,
    curve: Interval(
      0.0,
      0.5,
      curve: _menuCurve,
    ),
  ),
);

late final Animation<Offset> _screenOffset = Tween(
  begin: Offset.zero,
  end: const Offset(0.5, 0),
).animate(
  CurvedAnimation(
    parent: _menuController,
    curve: Interval(
      0.5,
      1.0,
      curve: _menuCurve,
    ),
  ),
);
```

## 5.13 Menu Slide

- profileSilde

```dart
late final Animation<Offset> _profileSlide = Tween<Offset>(
  begin: const Offset(-1, 0),
  end: Offset.zero,
).animate(
  CurvedAnimation(
    parent: _menuController,
    curve: Interval(
      0.4,
      0.7,
      curve: _menuCurve,
    ),
  ),
);
```

## 5.14 Menu Animations

- menuAnimations

```dart
late final List<Animation<Offset>> _menuAnimations = [
  for (var i = 0; i < _menus.length; i++)
    Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _menuController,
        curve: Interval(
          0.4 + (0.1 * 1),
          0.7 + (0.1 * i),
          curve: _menuCurve,
        ),
      ),
    ),
];
```

# 6 RIVE

## 6.1 Importing Animations

```yaml
dependencies:
  rive: ^0.11.4
```

- download riv file to assets/animations

```dart
// touch lib/screens/rive_screen.dart
..
child: RiveAnimation.asset(
  "assets/animations/old-man-animation.riv",
  artboard: "Dwarf Panel",
  onInit: _onInit,
  stateMachines: const ["State Machine 1"],
),
```

## 6.3 State Changes

```dart
child: RiveAnimation.asset(
  "assets/animations/stars-animation.riv",
  artboard: "New Artboard",
  onInit: _onInit,
  stateMachines: const ["State Machine 1"],
),
```

- can get state on action

```dart
void _onInit(Artboard artboard) {
  _stateMachineController = StateMachineController.fromArtboard(
    artboard,
    "State Machine 1",
    onStateChange: (stateMachineName, stateName) {
      print(stateMachineName);
      print(stateName);
    },
  )!;
  artboard.addController(_stateMachineController);
}
```

## 6.4 Custom Animation

- custom animation by Rive editor
- State machine
- Timeline: set of state machines
- Keyframe: A point of animation

## 6.5 Animation Blur

```dart
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
```

## 6.6 State Machine

### custom-button-animation.riv

- active and idle Timeline
- State machine
  - Inputs
    - isActive
  - Listeners
    - pointerDown
      - btn
        - isActive: true
    - pointerUp
      - btn
        - isActive: false

# 7 MATERIAL MOTION

## 7.0 Introduction

- animation package by flutte team for material design

```yaml
dependencies:
  animations: 2.0.7
```

## 7.1 Container Transform

- OpenContainer: closedBuilder and openBuilder

```dart
// touch lib/screens/container_transform_screen.dart
itemBuilder: (context, index) => OpenContainer(
  closedElevation: 0,
  openElevation: 0,
  closedBuilder: (context, action) => Column(
    children: [
      Image.asset("assets/covers/${(index % 5) + 1}.jpg"),
      const Text('Dune Soundtrack'),
      const Text(
        'Hans Zimmer',
        style: TextStyle(
          fontSize: 14,
        ),
      )
    ],
  ),
  openBuilder: (context, action) =>
      DetailScreen(image: (index % 5) + 1),
),
```

## 7.2 Shared Axis

- PageTransitionSwitcher
- transitionBuilder gives primaryAnimation, secondaryAnimation
- SharedAxisTransition
  - animation: drives the [child]'s entrance and exit.
  - secondaryAnimation: transitions [child] when new content is pushed on top of it.
  - SharedAxisTransitionType: horizontal, vertical, scaled
- ValueKey: identify whole widget is changed

```dart
touch lib/screens/shared_axis_screen.dart
```

## 7.3 Fade Through

```dart
// touch lib/screens/fade_through_screen.dart

body: PageTransitionSwitcher(
  transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
      FadeThroughTransition(
    animation: primaryAnimation,
    secondaryAnimation: secondaryAnimation,
    child: child,
  ),
  ..
```

# 8 WALLET PROJECT

## 8.0 Introduction

- flutter_animate by gsiknner
  - https://flutter.gskinner.com/wonderous/
  - https://flutter.gskinner.com/flokk/
  - https://flutter.gskinner.com/vignettes/

```yaml
dependencies:
  flutter_animate: 4.1.1+1
```

## 8.1 Animate Widget

- basic effects by `Animate` widget

```dart
// touch lib/screens/wallet_screen.dart
child: Animate(
  effects: [
    FadeEffect(
      begin: 0,
      end: 1,
      duration: 5.seconds,
      curve: Curves.easeInCubic,
    ),
    ScaleEffect(
      alignment: Alignment.center,
      begin: Offset.zero,
      end: const Offset(1, 1),
      duration: 5.seconds,
    )
  ],
  child: ..,
),
```
