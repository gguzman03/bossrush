// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:basic/game_internals/player.dart';
import 'package:basic/game_internals/weather_manager.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game_internals/game_state.dart';
import '../game_internals/score.dart';
//import '../level_selection/levels.dart';
import '../player_progress/player_progress.dart';
import '../style/confetti.dart';
import '../style/my_button.dart';
import '../style/palette.dart';
import 'boss_rush.dart';

import "package:nes_ui/nes_ui.dart";

class PlaySessionScreen extends StatelessWidget {
  const PlaySessionScreen({super.key});

  static final _log = Logger('PlaySessionScreen');

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final api = "5a75920ab7bd192bf92a40977af3b9f3";
    //universal player object that will be used throughout the game and determine win conditions
    final player = Player();
    final startOfPlay = DateTime.now();
    
    var wm = WeatherManager(api);
    var weather = wm.getWeather();
    late BossRush game;

    return ChangeNotifierProvider(
      create: (context) => GameState(
        player: player,
        onWin: () => _playerWon(context, startOfPlay),
        onLoss: () => _playerLost(context, startOfPlay),
      ),
      child: Scaffold(
        backgroundColor: palette.backgroundPlaySession,
        body: FutureBuilder<String>(
          future: weather,
          builder: (context, snapshot) {
            late String weatherString;
            if (snapshot.connectionState != ConnectionState.done) {
              return  Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          Text(
                            "loading game :)",
                            style: TextStyle(fontFamily: "Permanent Marker", fontSize: 25, height:  1),)
                        ],
                    )

              );
            }
            if (snapshot.hasError || !snapshot.hasData) {
              weatherString = "Weather unavailable";
            } else {
              weatherString = snapshot.data!;
            }

            game = BossRush(weatherString, context.read<GameState>());

            return Stack(
              children: [
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkResponse(
                        onTap: () {
                          game.pauseEngine();
                          GoRouter.of(context).push('/pause', extra: game);
                        },
                        child: Image.asset(
                          'assets/images/pause.png',
                          semanticLabel: 'Pause',
                        ),
                      ),
                    ),
                    Expanded(
                      child: GameWidget(game: game),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static Future<void> _playerWon(
      BuildContext context, DateTime startOfPlay) async {
    final _log = Logger('PlaySessionScreen');
    _log.info('You win!');

    final score = Score(DateTime.now().difference(startOfPlay));
    context.read<AudioController>().playSfx(SfxType.congrats);

    GoRouter.of(context).push('/play/won', extra: {'score': score});
  }

  static Future<void> _playerLost(
      BuildContext context, DateTime startOfPlay) async {
    final _log = Logger('PlaySessionScreen');
    _log.info('Level lost...');

    final score = Score(DateTime.now().difference(startOfPlay));
    GoRouter.of(context).go('/play/lost', extra: {'score': score});
  }
}


//Formerly Stateful Widget, which incorporated celebration confetti

// /// This widget defines the entirety of the screen that the player sees when
// /// they are playing a level.
// ///
// /// It is a stateful widget because it manages some state of its own,
// /// such as whether the game is in a "celebration" state.
// class PlaySessionScreen extends StatefulWidget {
//   const PlaySessionScreen({super.key});

//   @override
//   State<PlaySessionScreen> createState() => _PlaySessionScreenState();
// }

// class _PlaySessionScreenState extends State<PlaySessionScreen> {
//   static final _log = Logger('PlaySessionScreen');

//   // static const _celebrationDuration = Duration(milliseconds: 2000);

//   // static const _preCelebrationDuration = Duration(milliseconds: 500);

//   //bool _duringCelebration = false;

//   late DateTime _startOfPlay;

//   late Player _player;
//   @override
//   void initState() {
//     super.initState();
//     //universal player object that will be used throughout the game and determine win conditions
//     _player = Player();
//     _startOfPlay = DateTime.now();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final palette = context.watch<Palette>();
//     final api = "5a75920ab7bd192bf92a40977af3b9f3";

//     var wm = WeatherManager(api);
//     var weather = wm.getWeather();
//     late BossRush game;

//     return MultiProvider(
//       providers: [
//         //Provider.value(value: widget.level),
//         // Create and provide the [GameState] object that will be used
//         // by widgets below this one in the widget tree.
//         ChangeNotifierProvider(
//           create: (context) => GameState(
//               //goal: widget.level.difficulty,
//               player: _player,
//               onWin: _playerWon,
//               onLoss: _playerLost),
//         ),
//       ],
//       child: IgnorePointer(
//         // Ignore all input during the celebration animation.
//         //ignoring: _duringCelebration,
//         child: Scaffold(
//           backgroundColor: palette.backgroundPlaySession,
//           body:
//               // The stack is how you layer widgets on top of each other.
//               // Here, it is used to overlay the winning confetti animation on top
//               // of the game.
//               Stack(
//             children: [
//               // This is the main layout of the play session screen,
//               // with a pause button on top and actual play area
//               // below
//               FutureBuilder<String>(
//                   future: weather,
//                   builder: (context, snapshot) {
//                     late String weatherString;
//                     //game is loading
//                     while (snapshot.connectionState != ConnectionState.done) {
//                       return Center(child: const CircularProgressIndicator());
//                     }
//                     if (snapshot.hasError) {
//                       // return Text("Error in fetching data: ${snapshot.error}");
//                       weatherString = "Weather unavailable";
//                     } else if (!snapshot.hasData) {
//                       weatherString = "Weather unavailable";
//                     } else {
//                       weatherString = snapshot.data!;
//                     }

//                     //game = BossRush(weatherString, context.read<GameState>());
//                     game = BossRush(weatherString, context.read<GameState>());
//                     return Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         //place the pause functionality here
//                         Align(
//                             alignment: Alignment.centerRight,
//                             child: InkResponse(
//                                 onTap: () {
//                                   //print("pause button pushed");
//                                   game.pauseEngine();
//                                   GoRouter.of(context)
//                                       .push('/pause', extra: game);
//                                 },
//                                 child: Image.asset('assets/images/pause.png',
//                                     semanticLabel: 'Pause'))),
//                         Expanded(
//                           // The actual UI of the game.
//                           child: GameWidget(game: game),
//                         ),
//                       ],
//                     );
//                   }),
//               // This is the confetti animation that is overlaid on top of the
//               // game when the player wins.
//               // SizedBox.expand(
//               //   child: Visibility(
//               //     visible: _duringCelebration,
//               //     child: IgnorePointer(
//               //       child: Confetti(
//               //         isStopped: !_duringCelebration,
//               //       ),
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _playerWon() async {
//     //game.pauseEngine();
//     //print("player won! playerWon() reached.");
//     _log.info('You win!');

//     final score = Score(
//       DateTime.now().difference(_startOfPlay),
//     );

//     // // Let the player see the game just after winning for a bit.
//     // await Future<void>.delayed(_preCelebrationDuration);
//     // if (!mounted) return;

//     // setState(() {
//     //   _duringCelebration = true;
//     // });

//     final audioController = context.read<AudioController>();
//     audioController.playSfx(SfxType.congrats);

//     // /// Give the player some time to see the celebration animation.
//     // await Future<void>.delayed(_celebrationDuration);
//     // if (!mounted) return;

//     GoRouter.of(context).push('/play/won', extra: {'score': score});
//   }

//   Future<void> _playerLost() async {
//     //print("player lost. playerLost() reached");
//     final score = Score(
//       //widget.level.number,
//       // widget.level.difficulty,
//       DateTime.now().difference(_startOfPlay),
//     );
//     _log.info('Level lost...');
//     GoRouter.of(context).go('/play/lost', extra: {'score': score});
//   }
// }

// /*
//   in the case of an emergency: replace body: GameWidget<BossRush> with the following code:

//  */
// // The stack is how you layer widgets on top of each other.
// // Here, it is used to overlay the winning confetti animation on top
// // of the game.
// // Stack(
// //             children: [
// //               // This is the main layout of the play session screen,
// //               // with a pause button on top and actual play area
// //               // below
// //               Column(
// //                 //mainAxisAlignment: MainAxisAlignment.center,
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   //place the pause functionality here
// //                   Align(
// //                       alignment: Alignment.centerRight,
// //                       child: InkResponse(
// //                           onTap: () => GoRouter.of(context).push('/pause'),
// //                           child: Image.asset('assets/images/pause.png',
// //                               semanticLabel: 'Pause'))),
// //                   const Spacer(),
// //                   Expanded(
// //                     // The actual UI of the game.
// //                     child: GameWidget(game: kDebugMode ? BossRush() : game),
// //                   ),
// //                   const Spacer(),
// //                   // Padding(
// //                   //   padding: const EdgeInsets.all(8.0),
// //                   //   child: MyButton(
// //                   //     onPressed: () => GoRouter.of(context).go('/play'),
// //                   //     child: const Text('Back'),
// //                   //   ),
// //                   // ),
// //                 ],
// //               ),
// //               // This is the confetti animation that is overlaid on top of the
// //               // game when the player wins.
// //               SizedBox.expand(
// //                 child: Visibility(
// //                   visible: _duringCelebration,
// //                   child: IgnorePointer(
// //                     child: Confetti(
// //                       isStopped: !_duringCelebration,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),

// //  GameWidget<BossRush>(
// //             key: const Key("play session"),
// //             game: game,
// //             overlayBuilderMap: {
// //               "Pause":  (context, game) {
// //                 return Positioned(
// //                     top: 20,
// //                     right: 10,
// //                     child: NesButton(
// //                       type: NesButtonType.normal,
// //                       onPressed: () => GoRouter.of(context).push('/pause'),
// //                       child: NesIcon(iconData: NesIcons.pause),
// //                     )

// //                     // InkResponse(
// //                     //       onTap:
// //                     //       child: Image.asset('assets/images/pause.png',
// //                     //           semanticLabel: 'Pause')
// //                     // )

// //                 );
// //               }

// //             },

// //           ),
