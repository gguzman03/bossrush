// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import "package:weather/weather.dart";
import 'package:location/location.dart';

import 'package:flame/game.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game_internals/level_state.dart';
//import '../level_selection/levels.dart';
import '../level_selection/boss_map.dart';

/// This widget defines the game UI itself, without things like the settings
/// button or the back button.
// class GameWidget extends StatelessWidget {
//   const GameWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     //don't need this for BossRush
//     //final level = context.watch<GameLevel>();

//     //might need this for BossRush
//     final levelState = context.watch<LevelState>();

// //This is the actual game itself (not the page that has the game)
//     // return Column(
//     //   children: [
//     //     Text('Drag the slider to 100% or above!'),
//     //     Slider(
//     //       label: 'Level Progress',
//     //       autofocus: true,
//     //       value: levelState.progress / 100,
//     //       onChanged: (value) => levelState.setProgress((value * 100).round()),
//     //       onChangeEnd: (value) {
//     //         context.read<AudioController>().playSfx(SfxType.wssh);
//     //         levelState.evaluate();
//     //       },
//     //     ),
//     //   ],
//     // );

//     return Text("game in progress :)");
//   }
//}

//TODO: implement a score notifier
class BossRush extends FlameGame with HasKeyboardHandlerComponents{
  // This CameraComponent object, as opposed to being a part of the Camera package,
  // comes from the Flame package to actually display the game.

  BossRush();

  @override
  Color backgroundColor() => const Color.fromARGB(255, 0, 200, 255);

  //stuff to add to the game
  late final CameraComponent cameraComponent;
  final bossMap = BossMap();

  FutureOr<void> onLoad() {
    //recommended camera resolution: 640x360
    cameraComponent = CameraComponent.withFixedResolution(
        world: bossMap, width: 640, height: 360);

    //adjust camera anchor so that the level map begins generating from the top left
    cameraComponent.viewfinder.anchor = Anchor.topLeft;

    //stuff to add, including the camera
    final components = [bossMap, cameraComponent];
    addAll(components);
    return super.onLoad();
  }

}
