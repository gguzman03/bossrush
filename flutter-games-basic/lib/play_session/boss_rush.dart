// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
//import 'dart:ui';

import 'package:basic/game_internals/player.dart';
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
class BossRush extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection, DragCallbacks {
  BossRush();

  @override
  Color backgroundColor() => const Color.fromARGB(255, 0, 200, 255);

  //stuff to add to the game

  // This CameraComponent object, as opposed to being a part of the Camera package,
  // comes from the Flame package to actually display the game.
  late final CameraComponent cameraComponent;

  late JoystickComponent joystick;
  Player player = Player();

  FutureOr<void> onLoad() async{

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
    addJoystick();
    return super.onLoad();
  }

  //to implement movement using the joystick, create an update(dt) method in boss_rush.

  // @override
  // void update(double dt) {
  //   switch (joystick.direction) {
  //     case JoystickDirection.left:
  //       player.currDirection = PlayerDirection.left;
  //       break;
  //     case JoystickDirection.right:
  //       player.currDirection = PlayerDirection.right;
  //       break;

  //     case JoystickDirection.up:
  //       player.jumped = true;
  //       break;
  //     default:
  //       break;
  //   }
  // }


  //a joystick to be added for mobile functionality
   Future<void> addJoystick() async {

    /*
    For whatever reason, the four statements below don't work
    */
    //Image knobImage = Image.asset("joystick_parts/Knob.png");
    //Sprite knobSprite = Sprite(knobImage);

    //Image baseImage = Image.asset("joystick_parts/Joystick_Base.png");
    // Sprite baseSprite = Sprite(baseImage);


    joystick = JoystickComponent(
        knob: SpriteComponent.fromImage(images.fromCache("joystick_parts/Knob.png")),
        background: SpriteComponent.fromImage(images.fromCache("joystick_parts/Joystick_Base.png")),
        //puts the joystick in the bottom left corner
        margin: const EdgeInsets.only(left: 32, bottom: 32)
      );

    add(joystick);
  }
}
