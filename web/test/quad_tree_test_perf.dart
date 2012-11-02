import 'package:unittest/unittest.dart' as UnitTest;
import'dart:math' as Math;
import '../oneday/geom/geom.dart';

void main() {
  QuadTree qt = defaultTree();
  Math.Random rand = defaultRandom();
  List< SimpleObject > objects = new List< SimpleObject >();

//  for( int i = 0; i < objectCount; i++ ){
//    objects.add( new SimpleObject( ))
//  }
}


QuadTree defaultTree() => new QuadTree(0, 0, 10000, 10000, 1);
Math.Random defaultRandom() => new Math.Random(1);
int objectSize = 10;

class SimpleObject implements IQuadStorable {
  Rect _rect;
  Vec2 velocity;
  SimpleObject(num x, num y, [num width=10, num height=10]) : _rect = new Rect(x,y,width,height), velocity = new Vec2(0,0);

  bool isInRect( Rect r ) => _rect.isInRect(r);
  bool intersectsRect( Rect r ) => _rect.intersectsRect(r);
  Vec2 getPosition() => _rect.getPosition();
  
  String toString() => _rect.toString();
}
