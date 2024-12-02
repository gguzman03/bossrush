// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:basic/game_internals/player.dart';
import 'package:flutter/foundation.dart';

/// An extremely silly example of a game state.
///
/// Tracks only a single variable, [progress], and calls [onWin] when
/// the value of [progress] reaches [goal].
class GameState extends ChangeNotifier {
  final VoidCallback onWin;
  final VoidCallback onLoss;

  //final int goal;

  Player player;

  GameState({required this.onWin, required this.onLoss, required this.player});

  // int _progress = 0;

  // int get progress => _progress;

  // void setProgress(int value) {
  //   _progress = value;
  //   notifyListeners();
  // }

  void evaluate() {
    if (player.hasWon) {
      onWin();
    } 
    else if (player.hasLost){
      onLoss();
    }
  }
}
