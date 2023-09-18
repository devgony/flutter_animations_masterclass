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
