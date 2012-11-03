import 'dart:math' as Math;
import '../oneday/geom/geom.dart' as geom;

geom.BarnesHutTree bt;

void main() {
  bt = new geom.BarnesHutTree(0, 0, 1000, 1000);
  var rand = new Math.Random( 1983 );
  SimpleObject so = null;
  for( int i = 0; i < 10; i++ ) {
    so = new SimpleObject( rand.nextDouble() * bt.quadRect.width, rand.nextDouble() * bt.quadRect.height );
    bt.add( so );
  }
  
//  geom.Vec2 force = bt.calculateForce(so, bt.quadTreeRoot );

//  print("Force: ${force}");
}



class SimpleObject extends geom.IBarnesHutStorable {
  geom.Vec2 position;
  geom.Vec2 velocity;
  num mass = 1;
  
  SimpleObject( num x, num y ) : position = new geom.Vec2(x,y), velocity = new geom.Vec2(0,0);

  bool isInRect( geom.Rect r ) => position.isInRect(r);
  bool intersectsRect( geom.Rect r ) => position.intersectsRect(r);
  geom.Vec2 getPosition() => position;
}
