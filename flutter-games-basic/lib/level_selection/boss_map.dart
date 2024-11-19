
import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class BossMap extends World{

//this map variable represents the game itself
late TiledComponent map;
/*
  a FutureOr<T> can return either an Object of type T or a Future<T>
*/
  FutureOr<void> onLoad() async{

    //the folling statement just makes the map, as opposed to adding it to the actual game.

    //the second parameter is the destination tile size, which should be consistent with the map. 
    // in this case, the map accepts 16x16.
    map = await TiledComponent.load("boss-rush-map.tmx", Vector2.all(16));

    //this part actually adds the map
    add(map);

    return super.onLoad();
  }

}