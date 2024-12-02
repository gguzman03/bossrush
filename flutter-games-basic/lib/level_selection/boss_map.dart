import 'dart:async';
import 'package:basic/game_internals/boss.dart';
import 'package:basic/game_internals/collision.dart';
import 'package:basic/game_internals/item.dart';
import 'package:basic/game_internals/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class BossMap extends World {

  List<Collision> blocks = [];
  final Player player;
  BossMap({required this.player});
//this map variable represents the game itself
  late TiledComponent map;

  Future<void> onLoad() async {
    //the following statement just makes the map, as opposed to adding it to the actual game.

    //the second parameter is the destination tile size, which should be consistent with the map.
    // in this case, the map accepts 16x16.
    map = await TiledComponent.load("boss-rush-map.tmx", Vector2.all(16));

    //this part actually adds the map
    add(map);

    final spawnPointsLayer = map.tileMap.getLayer<ObjectGroup>("spawn_points");

    for (final spawnPoint in spawnPointsLayer!.objects){
      switch (spawnPoint.class_){
        case 'Player':
          player.position = Vector2(spawnPoint.x, spawnPoint.y);
          add(player);
          break;        
        case 'Item':
          final item = Item(
            position: Vector2(spawnPoint.x, spawnPoint.y), 
            size: Vector2(spawnPoint.width, spawnPoint.height));
          add(item);
          break;
        case 'Boss':
          final boss = Boss(position: Vector2(spawnPoint.x, spawnPoint.y), 
            size: Vector2(spawnPoint.width, spawnPoint.height));
          add(boss);
        default:
          break;
      }

    }

    final collisionsLayer = map.tileMap.getLayer<ObjectGroup>("collisions");
        for (final collision in collisionsLayer!.objects) {
      switch (collision.class_) {
        case 'Platform':
          final platform = Collision(position: Vector2(collision.x, collision.y), 
          size: Vector2(collision.width, collision.height),
          isPlatform: true);
          blocks.add(platform);
          add(platform);
          break;
        default:
          final platform = Collision(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              );
          blocks.add(platform);
          add(platform);
      }
    }
    player.blocks = blocks;

    return super.onLoad();
  }
}
