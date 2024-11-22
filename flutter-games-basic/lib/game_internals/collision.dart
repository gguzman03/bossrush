import 'package:flame/components.dart';

class Collision extends PositionComponent{
  
  bool isPlatform;
  Collision({super.position, super.size, this.isPlatform = false})
  {debugMode = true;}

}