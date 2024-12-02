

import 'package:basic/play_session/boss_rush.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Fireball extends SpriteAnimationComponent with HasGameRef<BossRush>{


  Fireball({super.position, super.size});

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());

    //animation = SpriteAnimation.fromFrameData(image, data);

    return super.onLoad();
  }

}