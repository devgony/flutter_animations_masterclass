import 'package:flutter/material.dart';
import 'package:flutter_animations_masterclass/screens/explicit_animations_screen.dart';
import 'package:flutter_animations_masterclass/screens/implicit_animations_screen.dart';
import 'package:flutter_animations_masterclass/screens/rive_screen_balls.dart';
import 'package:flutter_animations_masterclass/screens/rive_screen_button.dart';
import 'package:flutter_animations_masterclass/screens/rive_screen_stars.dart';
import 'package:flutter_animations_masterclass/screens/rive_screen_old_man.dart';
import 'package:flutter_animations_masterclass/screens/shared_axis_screen.dart';
import 'package:flutter_animations_masterclass/screens/swiping_cards_screen.dart';

import 'apple_watch_screen.dart';
import 'container_transform_screen.dart';
import 'fade_through_screen.dart';
import 'music_player_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _goToPage(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Animations'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const ImplicitAnimationsScreen(),
                );
              },
              child: const Text('Implicit Animations'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const ExplicitAnimationsScreen(),
                );
              },
              child: const Text('Explicit Animations'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const AppleWatchScreen(),
                );
              },
              child: const Text('Apple Watch'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const SwipingCardsScreen(),
                );
              },
              child: const Text('Swiping Cards'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const MusicPlayerScreen(),
                );
              },
              child: const Text('Music Player'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const RiveScreenOldMan(),
                );
              },
              child: const Text('Rive-oldMan'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const RiveScreenStars(),
                );
              },
              child: const Text('Rive-stars'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const RiveScreenBalls(),
                );
              },
              child: const Text('Rive-balls'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const RiveScreenButton(),
                );
              },
              child: const Text('Rive-button'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const ContainerTransformScreen(),
                );
              },
              child: const Text('Container Transform'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const SharedAxisScreen(),
                );
              },
              child: const Text('Shared Axis'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const FadeThroughScreen(),
                );
              },
              child: const Text('Fade Through'),
            ),
          ],
        ),
      ),
    );
  }
}
