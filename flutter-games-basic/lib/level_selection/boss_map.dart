import 'dart:async';
import 'package:basic/game_internals/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class BossMap extends World {
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
          final player = Player(
               position: Vector2(spawnPoint.x, spawnPoint.y));
          add(player);
          break;
        default:
      }

    }
    return super.onLoad();
  }
}
