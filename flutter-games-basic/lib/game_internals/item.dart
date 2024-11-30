import 'dart:async';

import 'package:basic/play_session/boss_rush.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Item extends SpriteAnimationComponent with HasGameRef<BossRush>{

  
  //TODO: use this boolean to create collection animation
  bool _isCollected = false;

  Item({super.position, super.size});

  //in case of multiple items
  //final double stepTime = 0.05;

    @override
  Future<void> onLoad() async{
    debugMode = true;
    priority = -1; 

    add(RectangleHitbox(

      collisionType: CollisionType.passive
    ));
    animation = await game.loadSpriteAnimation(
      "item/item.png", 
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2(16,25),
        stepTime: 0.25
        
      ));
    return super.onLoad();
   
  }
  
  void playerCollide() {
    //fthis makes it look like the object disappears when collected
      removeFromParent();
      _isCollected = true;

  }


  


}