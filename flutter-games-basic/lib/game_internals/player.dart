



import 'package:flame/components.dart';

class Player extends SpriteAnimationGroupComponent<PlayerState>{



}


enum PlayerState {
  running,
  jumping,
  falling,
  standing
}
