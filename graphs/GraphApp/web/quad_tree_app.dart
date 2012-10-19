import 'dart:html';
import 'dart:math' as Math;
import 'oneday/geom/geom.dart' as geom;
//import 'oneday/ds/ds.dart';
//import 'oneday/ds/layout/layout.dart';

//GGraph graph;
//ForceDirectedGraph forceGraph;
geom.QuadTree qt;

CanvasRenderingContext2D context;
int lastTime = null;

class SimpleObject implements geom.IQuadStorable {
  geom.Vec2 position;
  geom.Vec2 velocity;
  SimpleObject( num x, num y ) : position = new geom.Vec2(x,y), velocity = new geom.Vec2(0,0);
  
  bool isInRect( geom.Rect r ) => position.isInRect(r);
  bool intersectsRect( geom.Rect r ) => position.intersectsRect(r);
}
void main() { 
  CanvasElement canvas = query("#container");
  context = canvas.context2d;
  
  qt = new geom.QuadTree(0, 0, 1000);
  
  var rand = new Math.Random( new Date.now().millisecondsSinceEpoch );
  for( int i = 0; i < 50; i++ ) {
    var so = new SimpleObject( rand.nextDouble() * canvas.width, rand.nextDouble() * canvas.height );
    qt.add( so );
  }
}

void start() {
  lastTime = new Date.now().millisecondsSinceEpoch;
  window.requestAnimationFrame( update );
}

void update( int time ) {
  var delta = (time-lastTime)/1000;
  lastTime = time;
  
//  forceGraph.tick( delta );
  
  draw( delta );
  window.requestAnimationFrame( update );
}

void draw( num delta ) {
//  graph.nodes.forEach( void f(int key, GGraphNode thisNode) {
//    ( thisNode.value as geom.DrawableCircle ).draw( context );
//  });
}



