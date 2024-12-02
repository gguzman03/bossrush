
/*
  The joystick gets buggy when inputting a player jump. A specialized JumpButton 
  widget takes care of this issue.

*/


import 'dart:async';

import 'package:basic/play_session/boss_rush.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class JumpButton extends SpriteComponent with HasGameRef<BossRush>, TapCallbacks{

  JumpButton();
   
  @override
  FutureOr<void> onLoad() async{
    priority = 10;
    sprite = Sprite(game.images.fromCache("Jump_Button.png"));
    position = Vector2(
      game.size.x - 32 - 64, 
      game.size.y - 32 - 64);

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.jumped =true;
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event){
    game.player.jumped = false;
    super.onTapUp(event);
  }


}