



import 'package:basic/play_session/boss_rush.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
//import 'package:flutter/animation.dart';

class Player extends SpriteAnimationGroupComponent<PlayerState> 
  with HasGameRef<BossRush>
{

   Player({super.position});

    //THIS SEGMENT WAS TAKEN FROM LAB9
  // Used to store the last position of the player, so that we later can
  // determine which direction that the player is moving.
  final Vector2 _lastPosition = Vector2.zero();

//a separate variable in the case the step time needs to change
  final double stepTime = 0.1;

  Future<void> onLoad() async{

      //FIXME: as a placeholder, these are all the same animation (idle), regardless of action
      animations = {
      PlayerState.standing: await game.loadSpriteAnimation(
              "player_sprites/lil_dude/lil-dude-idle.png",
            SpriteAnimationData.sequenced(
            amount: 12,
            textureSize: Vector2(25,32),
            stepTime: stepTime,
            ),
      ),
      PlayerState.running: await game.loadSpriteAnimation(
        "player_sprites/lil_dude/lil-dude-idle.png",
        SpriteAnimationData.sequenced(
          amount: 12,
          textureSize: Vector2(25, 32),
          stepTime: stepTime,
        ),
      ),
      PlayerState.jumping: await game.loadSpriteAnimation(
        "player_sprites/lil_dude/lil-dude-idle.png",
        SpriteAnimationData.sequenced(
          amount: 12,
          textureSize: Vector2(25, 32),
          stepTime: stepTime,
        ),
      ),

      PlayerState.falling: await game.loadSpriteAnimation(
        "player_sprites/lil_dude/lil-dude-idle.png",
        SpriteAnimationData.sequenced(
          amount: 12,
          textureSize: Vector2(25, 32),
          stepTime: stepTime,
        ),
      )
      };


    //default animation
    //"current" is a provided setter
      current = PlayerState.standing;

      _lastPosition.setFrom(position);

       add(CircleHitbox());





  }

}


//standing = idle
enum PlayerState {
  running,
  jumping,
  falling,
  standing
}
enum PlayerDirection{
  left,
  right,
  none
}