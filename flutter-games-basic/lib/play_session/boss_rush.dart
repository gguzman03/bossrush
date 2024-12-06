// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
//import 'dart:ui';

import 'package:basic/game_internals/jump_button.dart';
import 'package:basic/game_internals/player.dart';
import 'package:basic/game_internals/weather_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import "package:weather/weather.dart";
import 'package:location/location.dart';

import 'package:flame/game.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game_internals/game_state.dart';
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

//TODO: weather management is wonky. This solution is solely for fdunctionality.
// adjust the router, main menu screen, and this file to add parameters for weather soon.
class BossRush extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection, TapCallbacks {
   String color;
  BossRush(this.color);

  Map<String, Color> weatherColors= {
    "Thunderstorm": Color.fromARGB(255, 38, 38, 38),
    "Drizzle": Color.fromARGB(255, 153, 198, 210),
    "Rain":Color.fromARGB(255, 52, 107, 126),
    "Snow":Color.fromARGB(255, 234, 234, 234),
    "Clear": Color.fromARGB(255, 122, 226, 255),
    "Clouds": Color.fromARGB(255, 150, 150, 150),
    "Mist": Color.fromARGB(255, 193, 246, 255),
    "Smoke": Color.fromARGB(255, 86, 77, 77),
    "Haze": Color.fromARGB(255, 92, 193, 188),
    "Dust":Color.fromARGB(255, 126, 107, 65),
    "Fog":Color.fromARGB(173, 141, 169, 184),
    "Sand":Color.fromARGB(172, 255, 234, 130),
    "Ash":Color.fromARGB(255, 125, 0, 0), 
    "Squall":Color.fromARGB(255, 205, 237, 255),
    "Tornado": Color.fromARGB(255, 0, 14, 25),
    "Weather unavailable": Color.fromARGB(255, 125, 0, 0)
  };

  @override
  Color backgroundColor() {
      var backgroundColor = weatherColors[color]!;
      return backgroundColor;
  } 

  //stuff to add to the game

  // This CameraComponent object, as opposed to being a part of the Camera package,
  // comes from the Flame package to actually display the game.
  late final CameraComponent cameraComponent;

  late JoystickComponent joystick;
  Player player = Player();

  //testing boolean for mobile functionality.
  //this will be set false when adding a new feature for the game,
  //then true when playing on mobile or adding a new mobile feature.
  bool isMobile = false;

  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    final bossMap = BossMap(player: player);

    //recommended camera resolution: 640x360
    cameraComponent = CameraComponent.withFixedResolution(
        world: bossMap, width: 640, height: 360);

    //adjust camera anchor so that the level map begins generating from the top left
    cameraComponent.viewfinder.anchor = Anchor.topLeft;

    //stuff to add, including the camera
    final components = [bossMap, cameraComponent];
    addAll(components);

  //though my proposal only mentions keyboard functionality, 
  //this is the attempt at pure mobile functionality as well
  // (i.e. not with a keyboard) 
    if (isMobile) {
      addJoystick();
      add(JumpButton());
    }
    return super.onLoad();
  }

  //to implement movement using the joystick, create an update(dt) method in boss_rush.
  @override
  void update(double dt) {
    if (isMobile) {
      switch (joystick.direction) {
        case JoystickDirection.left:
        case JoystickDirection.upLeft:
        case JoystickDirection.downLeft:
          player.horiz = -1;
          break;
        case JoystickDirection.right:
        case JoystickDirection.upRight:
        case JoystickDirection.downRight:
          player.horiz = 1;
          break;
        // case JoystickDirection.up:
        //   player.jumped = true;
        //   break;
        default:
          player.horiz = 0;
          break;
      }
    }
    super.update(dt);
  }

  //a joystick to be added for mobile functionality
  Future<void> addJoystick() async {
    joystick = JoystickComponent(
        priority: 10,
        knob: CircleComponent(radius: 15, paint: BasicPalette.gray.paint()),
        background:
            CircleComponent(radius: 30, paint: BasicPalette.black.paint()),
        //puts the joystick in the bottom left corner
        margin: const EdgeInsets.only(left: 2, bottom: 2));

    add(joystick);
    //cameraComponent.viewport.add(joystick);
  }


}
