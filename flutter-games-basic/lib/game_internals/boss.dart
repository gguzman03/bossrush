
import 'package:basic/play_session/boss_rush.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Boss extends SpriteAnimationComponent with HasGameRef<BossRush>, CollisionCallbacks{

  Boss({super.position, super.size});


  @override
  Future<void> onLoad() async {

    debugMode = false;
    //the current placeholder hitbox will be minus the boss's wings, rezulting in dimensions of 76x96
    add(RectangleHitbox(size: Vector2(76,104)));

    animation = await game.loadSpriteAnimation(
      "boss/boss.png", 
      SpriteAnimationData.sequenced(
        amount: 6, 
        stepTime: 0.15, 
        textureSize: Vector2(102, 104)));

     return super.onLoad();
  }





  //For now, nothing happens to the boss when it collides with the player, 
  //so unlike item.dart, a onCollision() method for boss.dart
  //is currently not needed. 

}