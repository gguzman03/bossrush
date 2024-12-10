import 'package:basic/play_session/boss_rush.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Fireball extends SpriteAnimationComponent with HasGameRef<BossRush> {
  
  final double initialX;
  final double initialY;
  
  Fireball({super.position, super.size, required this.initialX, required this.initialY});

  @override
  Future<void> onLoad() async {
    //debugMode = true;
    priority = -1;
    add(RectangleHitbox());
    animation = await game.loadSpriteAnimation(
        "boss/fireball.png",
        SpriteAnimationData.sequenced(
        amount: 2, 
        stepTime: 0.15, 
        textureSize: Vector2.all(32)
      )
    );
    return super.onLoad();
  }

  @override
  void update(double dt){
    if (position.x + 32 < 0){
      position.x = initialX;
    } 
    position.x -= 100 * dt;
    super.update(dt);
  }

}
