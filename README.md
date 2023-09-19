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
