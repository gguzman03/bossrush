
import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Hazard extends PositionComponent{
  Hazard({super.position, super.size});

  @override
  FutureOr<void> onLoad(){
    debugMode = true;
      add(RectangleHitbox());

      return super.onLoad();
  }
}