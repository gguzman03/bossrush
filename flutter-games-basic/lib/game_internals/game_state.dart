// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:basic/game_internals/player.dart';
import 'package:flutter/foundation.dart';

/// An extremely silly example of a game state.
///
/// Tracks only a single variable, [progress], and calls [onWin] when
/// the value of [progress] reaches [goal].
class GameState with ChangeNotifier {
  final VoidCallback onWin;
  final VoidCallback onLoss;

  //final int goal;

  //player object to keep track of game status
  Player player;

  GameState({required this.onWin, required this.onLoss, required this.player}){

    //the listener to listen to the change in value (win/loss)
    player.addListener(evaluate);

  }
  
  void evaluate() {
    if (player.hasWon) {
      //print("evaluate: player has won");
      onWin();
      //resets flag for next time
      player.hasWon = false;
    } 
    else if (player.hasLost){
      //print("evaluate: player has lost");
      onLoss();
      player.hasLost = false;
    }
  }

}
