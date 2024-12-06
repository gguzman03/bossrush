import 'package:flame/components.dart';

class Collision extends PositionComponent{
  
  bool isPlatform;
  //bool isHazard;
  Collision({super.position, super.size, this.isPlatform = false})
  {debugMode = false;}

}