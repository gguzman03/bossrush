import 'package:basic/game_internals/boss.dart';
import 'package:basic/game_internals/collision.dart';
import 'package:basic/game_internals/hazard.dart';
import 'package:basic/game_internals/item.dart';
import 'package:basic/play_session/boss_rush.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/hardware_keyboard.dart';

//standing = idle
enum PlayerState { running, jumping, falling, standing }

//an enum of player movement direction. "none" indicates the player
// is not moving
enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<BossRush>, KeyboardHandler, CollisionCallbacks, ChangeNotifier {
  Player({super.position});

  ///[stepTime] is a separate variable in the case the step time needs to change
  final double stepTime = 0.1;

  PlayerDirection currDirection = PlayerDirection.none;
  double horiz = 0.0;
  double speed = 100;
  Vector2 velocity = Vector2.zero();
  List<Collision> blocks = [];
  bool isRight = true;

  //the player should only be able to jump once from the ground.
  //there will be flags for if the player is grounded and if the player can jump
  bool jumped = false;
  bool grounded = false;

  //value for gravity (9.8 m/s)
  final double g = 9.8;
  //force of player jump meant to counteract gravity; test value is 460
  final double fJump = 460;
  //like in real life, when falling, we stop accelerating when we reach terminal velocity
  final double terminalVelocity = 300;

  ///On mobile, the frame rate is different compared to web. This causes certain bugs, such
  ///as the player jumping too high. The [dtMobile] double handles that issue.

  final double dtMobile = 1 / 60;

  ///Further more, the below [accumulatedTime] variable

  double accumulatedTime = 0;

  //This boolean flag checks if the player has the necessary item to win
  bool hasItem = false;

  //game status checkers
  bool hasWon = false;
  bool hasLost = false;

  @override
  Future<void> onLoad() async {
    //debugMode = true;

    if (!hasItem) {
      //TODO: create jumping and falling animations
      animations = {
        PlayerState.standing: await game.loadSpriteAnimation(
          "player_sprites/lil_dude/lil-dude-idle.png",
          SpriteAnimationData.sequenced(
            amount: 12,
            textureSize: Vector2(25, 32),
            stepTime: stepTime,
          ),
        ),
        PlayerState.running: await game.loadSpriteAnimation(
          "player_sprites/lil_dude/lil-dude-running.png",
          SpriteAnimationData.sequenced(
            amount: 11,
            textureSize: Vector2(25, 32),
            stepTime: stepTime - 0.05,
          ),
        ),
        PlayerState.jumping: await game.loadSpriteAnimation(
          "player_sprites/lil_dude/lil-dude-idle.png",
          SpriteAnimationData.sequenced(
            amount: 11,
            textureSize: Vector2(25, 32),
            stepTime: stepTime,
          ),
        ),
        PlayerState.falling: await game.loadSpriteAnimation(
          "player_sprites/lil_dude/lil-dude-idle.png",
          SpriteAnimationData.sequenced(
            amount: 11,
            textureSize: Vector2(25, 32),
            stepTime: stepTime,
          ),
        )
      };
    } else {}

    //default animation
    //"current" is a provided setter
    current = PlayerState.standing;

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    accumulatedTime += dt;

    while (accumulatedTime >= dtMobile){
      _updateState();
      _updatePlayerMovement(dtMobile);
      _checkHorizCollisions();
      //always check gravity after checking horizontal collisions
      _gravity(dtMobile);
      _checkVertCollisions();
      
      accumulatedTime -= dtMobile;
    } 

    

    //update, similar to Sonic Dash
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    //TODO: play sound effects here!
    if (other is Item) {
      other.playerCollide();
      hasItem = true;
      print("player has item!");
    }

    //TODO: boss logic
    //if other is boss
    else if (other is Boss) {
      //if player has item
      if (hasItem) {
        //player win
        game.pauseEngine();
        hasWon = true;
        notifyListeners();
        //debug statement
        //print("player hasWon: $hasWon");
      } else {
        //player lose
        game.pauseEngine();
        hasLost = true;
        notifyListeners();
        //print("player got hit by the boss..., hasLost: $hasLost");    
      }
    }      
    else if (other is Hazard){
      //if the collision is a hazard, you lose regardless
            //player loses
            game.pauseEngine();
            hasLost = true;
            //print("player fell on hazard and lost, hasLost: $hasLost");
           notifyListeners();

      }

      //game.gameState.evaluate();
      //TODO: if the collision is a fireball, player loses regardless
    super.onCollision(intersectionPoints, other);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horiz = 0.0;
    final leftKey = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final rightKey = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horiz += leftKey ? -1 : 0;
    horiz += rightKey ? 1 : 0;

    jumped = keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp);

    return super.onKeyEvent(event, keysPressed);
  }

  void _updateState() {
    PlayerState newState = PlayerState.standing;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    if (velocity.x != 0) {
      newState = PlayerState.running;
    }

    if (velocity.y > 0) {
      newState = PlayerState.falling;
    }
    if (velocity.y < 0) {
      newState = PlayerState.jumping;
    }

    current = newState;
  }

  void _updatePlayerMovement(double dt) {
    if (jumped && grounded) {
      _jump(dt);
    }

    velocity.x = horiz * speed;
    position.x += velocity.x * dt;
  }

  void _checkHorizCollisions() {
    for (var block in blocks) {
      if (!block.isPlatform) {
        if (collisionCheck(this, block)) {
          //if colliding from the right
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - width;
          }
          //if colliding from the left
          else if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + width;
          }
        }
      }
    }
  }

//choose platform variables for the player's instance variables below (x, y, width, height)
//since they are both just objects in our tile map
  bool collisionCheck(Player player, Collision block) {
    final playerX = player.position.x;
    final playerY = player.position.y;
    final playerWidth = player.width;
    final playerHeight = player.height;

    final blockX = block.x;
    final blockY = block.y;
    final blockWidth = block.width;
    final blockHeight = block.height;

    //when the player is moving left, the model itself is mirrored,
    //and thus the x-value is on the opposite side.
    //fixedX accounts for that oversight.
    final fixedX = player.scale.x < 0 ? playerX - playerWidth : playerX;

    final fixedY = block.isPlatform ? playerY + playerHeight : playerY;

    bool isColliding = false;

    /*
      first condition: if the player's height falls within the block (from where the block starts to its height)
      second condtion: 
      third condition: if the player's width falls within the block (from where the block starts to its width)
      fourth condition:

    */
    if (fixedY < blockY + blockHeight &&
        playerY + playerHeight > blockY &&
        fixedX < blockX + blockWidth &&
        fixedX + playerWidth > blockX) {
      isColliding = true;
    }

    return isColliding;
  }

  void _gravity(double dt) {
    velocity.y += g;
    velocity.y.clamp(-fJump, terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVertCollisions() {
    for (final block in blocks) {
      if (block.isPlatform) {
        if (collisionCheck(this, block)) {
          //if colliding from above
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - height;
            grounded = true;
          }
        }
      } else {
        if (collisionCheck(this, block)) {
          //if colliding from above
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - height;
            grounded = true;
          }
          //if colliding from below
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height;
          }
        }
      }
    }
  }

  void _jump(double dt) {
    velocity.y = -fJump;
    position.y += velocity.y * dt;
    jumped = false;
    grounded = false;
  }
}
